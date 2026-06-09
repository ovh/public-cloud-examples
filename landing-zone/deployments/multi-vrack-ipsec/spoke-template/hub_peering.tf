########################################################################################
# Hub-side peering (Day-2 spokes)
########################################################################################

locals {
  hub_ipsec_interface_name = "ipsec${var.ipsec_reqid}"
  hub_vti_gateway_name     = "VTISpokeGW${var.ipsec_reqid}"
}

resource "time_sleep" "wait_spoke_ready" {
  depends_on      = [module.spoke]
  create_duration = "30s"
}

########################################################################################
# 1. PSK
########################################################################################

resource "restapi_object" "hub_psk" {
  provider     = restapi.hub_opnsense
  path         = "/ipsec/pre_shared_keys/add_item"
  read_path    = "/ipsec/pre_shared_keys/get_item/{id}"
  destroy_path = "/ipsec/pre_shared_keys/del_item/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_spoke_ready]

  data = jsonencode({
    preSharedKey = {
      enabled      = "1"
      ident        = var.hub_wan_carp_ip
      remote_ident = module.spoke.floating_ip
      keyType      = "PSK"
      Key          = var.ipsec_pre_shared_key
      description  = "IPsec Tunnel PSK (reqid=${var.ipsec_reqid})"
    }
  })
}

resource "time_sleep" "wait_after_psk" {
  depends_on      = [restapi_object.hub_psk]
  create_duration = "3s"
}

########################################################################################
# 2. Connection
########################################################################################

resource "restapi_object" "hub_connection" {
  provider     = restapi.hub_opnsense
  path         = "/ipsec/connections/add_connection"
  read_path    = "/ipsec/connections/get_connection/{id}"
  destroy_path = "/ipsec/connections/del_connection/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_psk]

  data = jsonencode({
    connection = {
      enabled      = "1"
      proposals    = "aes256gcm16-sha256-ecp256"
      unique       = "no"
      version      = "2"
      mobike       = "0"
      local_addrs  = var.hub_wan_carp_ip
      remote_addrs = module.spoke.floating_ip
      rekey_time   = "86400"
      keyingtries  = "0"
      description  = "Phase 1 to Spoke (reqid=${var.ipsec_reqid})"
    }
  })
}

resource "time_sleep" "wait_after_connection" {
  depends_on      = [restapi_object.hub_connection]
  create_duration = "3s"
}

########################################################################################
# 3. Local auth
########################################################################################

resource "restapi_object" "hub_local_auth" {
  provider     = restapi.hub_opnsense
  path         = "/ipsec/connections/add_local"
  read_path    = "/ipsec/connections/get_local/{id}"
  destroy_path = "/ipsec/connections/del_local/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_connection]

  data = jsonencode({
    local = {
      enabled     = "1"
      connection  = restapi_object.hub_connection.id
      round       = "0"
      auth        = "psk"
      description = ""
    }
  })
}

resource "time_sleep" "wait_after_local_auth" {
  depends_on      = [restapi_object.hub_local_auth]
  create_duration = "3s"
}

########################################################################################
# 4. Remote auth
########################################################################################

resource "restapi_object" "hub_remote_auth" {
  provider     = restapi.hub_opnsense
  path         = "/ipsec/connections/add_remote"
  read_path    = "/ipsec/connections/get_remote/{id}"
  destroy_path = "/ipsec/connections/del_remote/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_local_auth]

  data = jsonencode({
    remote = {
      enabled     = "1"
      connection  = restapi_object.hub_connection.id
      round       = "0"
      auth        = "psk"
      description = ""
    }
  })
}

resource "time_sleep" "wait_after_remote_auth" {
  depends_on      = [restapi_object.hub_remote_auth]
  create_duration = "3s"
}

########################################################################################
# 5. Child SA
########################################################################################

resource "restapi_object" "hub_child_sa" {
  provider     = restapi.hub_opnsense
  path         = "/ipsec/connections/add_child"
  read_path    = "/ipsec/connections/get_child/{id}"
  destroy_path = "/ipsec/connections/del_child/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_remote_auth]

  data = jsonencode({
    child = {
      enabled       = "1"
      connection    = restapi_object.hub_connection.id
      reqid         = tostring(var.ipsec_reqid)
      esp_proposals = "aes128gcm16-ecp256"
      start_action  = "trap|start"
      close_action  = "start"
      dpd_action    = "start"
      mode          = "tunnel"
      policies      = "0"
      local_ts      = "0.0.0.0/0"
      remote_ts     = "0.0.0.0/0"
      rekey_time    = "43200"
      description   = "Phase 2 to Spoke (reqid=${var.ipsec_reqid})"
    }
  })
}

resource "time_sleep" "wait_after_child_sa" {
  depends_on      = [restapi_object.hub_child_sa]
  create_duration = "3s"
}

########################################################################################
# 6. VTI
########################################################################################

resource "restapi_object" "hub_vti" {
  provider     = restapi.hub_opnsense
  path         = "/ipsec/vti/add"
  read_path    = "/ipsec/vti/get/{id}"
  destroy_path = "/ipsec/vti/del/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_child_sa]

  data = jsonencode({
    vti = {
      enabled       = "1"
      reqid         = tostring(var.ipsec_reqid)
      local         = var.hub_wan_carp_ip
      remote        = module.spoke.floating_ip
      tunnel_local  = cidrhost(var.vti_link_cidr, 1)
      tunnel_remote = cidrhost(var.vti_link_cidr, 2)
      description   = "VTI to Spoke (reqid=${var.ipsec_reqid})"
    }
  })
}

########################################################################################
# 7. Reconfigure IPsec
# Note: the local-exec calls below pass hub_api_key and hub_api_secret as command-line
# arguments (curl -u). These values appear briefly in the process list on the machine
# running tofu apply. Run on a dedicated workstation or isolated CI runner, and do not
# enable TF_LOG=TRACE/DEBUG in production.
########################################################################################

resource "null_resource" "hub_ipsec_reconfigure" {
  depends_on = [
    restapi_object.hub_psk,
    restapi_object.hub_connection,
    restapi_object.hub_local_auth,
    restapi_object.hub_remote_auth,
    restapi_object.hub_child_sa,
    restapi_object.hub_vti
  ]

  provisioner "local-exec" {
    command = "curl -ks -u ${var.hub_api_key}:${var.hub_api_secret} -X POST https://${var.hub_floating_ip}:8443/api/ipsec/service/reconfigure"
  }
}

resource "time_sleep" "wait_after_ipsec_reconfigure" {
  depends_on      = [null_resource.hub_ipsec_reconfigure]
  create_duration = "3s"
}

########################################################################################
# 8. Gateway
########################################################################################

resource "restapi_object" "hub_gateway" {
  provider     = restapi.hub_opnsense
  path         = "/routing/settings/add_gateway"
  read_path    = "/routing/settings/get_gateway/{id}"
  destroy_path = "/routing/settings/del_gateway/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_ipsec_reconfigure]

  data = jsonencode({
    gateway_item = {
      disabled        = "0"
      name            = local.hub_vti_gateway_name
      descr           = "VTI toward Spoke (reqid=${var.ipsec_reqid})"
      interface       = local.hub_ipsec_interface_name
      ipprotocol      = "inet"
      gateway         = cidrhost(var.vti_link_cidr, 2)
      defaultgw       = "0"
      fargw           = "0"
      monitor_disable = "1"
      priority        = "255"
    }
  })
}

########################################################################################
# 9. Reconfigure routing
########################################################################################

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

########################################################################################
# 10. Route
########################################################################################

resource "restapi_object" "hub_route" {
  provider     = restapi.hub_opnsense
  path         = "/routes/routes/addroute"
  read_path    = "/routes/routes/getroute/{id}"
  destroy_path = "/routes/routes/delroute/{id}"
  id_attribute = "uuid"

  depends_on = [time_sleep.wait_after_routing_reconfigure]

  data = jsonencode({
    route = {
      network  = var.spoke_private_lan_cidr
      gateway  = local.hub_vti_gateway_name
      descr    = "Spoke LAN via IPsec VTI (reqid=${var.ipsec_reqid})"
      disabled = "0"
    }
  })
}

########################################################################################
# 11. Reconfigure routes
########################################################################################

resource "null_resource" "hub_routes_reconfigure" {
  depends_on = [restapi_object.hub_route]

  provisioner "local-exec" {
    command = "curl -ks -u ${var.hub_api_key}:${var.hub_api_secret} -X POST https://${var.hub_floating_ip}:8443/api/routes/routes/reconfigure"
  }
}
