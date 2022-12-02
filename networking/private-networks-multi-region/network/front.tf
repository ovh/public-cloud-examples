resource "openstack_networking_network_v2" "frontnetwork" {
  for_each = { for o in var.multi : o.region => o }

  name           = var.common.frontNwName
  region         = each.key
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "frontsubnet" {
  for_each = { for o in var.multi : o.region => o }

  network_id      = openstack_networking_network_v2.frontnetwork[each.key].id
  name            = var.common.frontSubnetName
  region          = each.key
  cidr            = each.value.frontSubnetCIDR
  enable_dhcp     = false
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
}

resource "openstack_networking_router_v2" "frontrouter" {
  for_each = { for o in var.multi : o.region => o }

  region              = each.key
  name                = var.common.frontRouterName
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.Ext-Net[each.key].id
}

resource "openstack_networking_router_interface_v2" "frontRouterInterface" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.frontrouter[each.key].id
  subnet_id = openstack_networking_subnet_v2.frontsubnet[each.key].id
}
