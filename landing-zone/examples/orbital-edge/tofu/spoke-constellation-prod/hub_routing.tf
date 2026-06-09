########################################################################################
# Hub-side routing (Day-2) — add routes to the spoke LANs through the transit VLAN
########################################################################################

locals {
  hub_spoke_gateway_name = "Spoke${replace(title(var.spoke_name), "-", "")}GW"
}

resource "time_sleep" "wait_spoke_ready" {
  depends_on      = [module.spoke]
  create_duration = "10s"
}

# 1. Hub gateway: LAN interface → spoke router IP on the transit VLAN
resource "restapi_object" "hub_gateway" {
  provider     = restapi.hub_opnsense
  path         = "/routing/settings/add_gateway"
  read_path    = "/routing/settings/get_gateway/{id}"
  destroy_path = "/routing/settings/del_gateway/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_spoke_ready]

  data = jsonencode({
    gateway_item = {
      disabled        = "0"
      name            = local.hub_spoke_gateway_name
      descr           = "Spoke ${var.spoke_name} transit router (via hub LAN)"
      interface       = "lan"
      ipprotocol      = "inet"
      gateway         = module.spoke.transit_router_ip
      defaultgw       = "0"
      fargw           = "0"
      monitor_disable = "1"
      priority        = "255"
    }
  })
}

# 2. Reconfigure routing
resource "null_resource" "hub_routing_reconfigure" {
  depends_on = [restapi_object.hub_gateway]

  provisioner "local-exec" {
    command = "curl -ks -u ${var.hub_api_key}:${var.hub_api_secret} -X POST https://${var.hub_floating_ip}:8443/api/routing/settings/reconfigure"
  }
}

resource "time_sleep" "wait_after_routing_reconfigure" {
  depends_on      = [null_resource.hub_routing_reconfigure]
  create_duration = "3s"
}

# 3. Static routes: one per spoke LAN network
resource "restapi_object" "hub_routes" {
  for_each = var.networks

  provider     = restapi.hub_opnsense
  path         = "/routes/routes/addroute"
  read_path    = "/routes/routes/getroute/{id}"
  destroy_path = "/routes/routes/delroute/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_routing_reconfigure]

  data = jsonencode({
    route = {
      network  = each.value.cidr
      gateway  = local.hub_spoke_gateway_name
      descr    = "Spoke ${var.spoke_name} LAN '${each.key}' via transit"
      disabled = "0"
    }
  })
}

# 4. Reconfigure routes
resource "null_resource" "hub_routes_reconfigure" {
  depends_on = [restapi_object.hub_routes]

  provisioner "local-exec" {
    command = "curl -ks -u ${var.hub_api_key}:${var.hub_api_secret} -X POST https://${var.hub_floating_ip}:8443/api/routes/routes/reconfigure"
  }
}
