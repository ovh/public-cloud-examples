resource "openstack_networking_network_v2" "network" {
  for_each		= { for o in var.z : o.region => o }

  name           	= "${each.value.pvNetworkName}"
  region		= "${each.key}"
  admin_state_up 	= "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  for_each              = { for o in var.z : o.region => o }

  network_id		= openstack_networking_network_v2.network[each.key].id
  name                 	= "${each.value.subnetName}"
  region               	= "${each.key}"
  cidr                 	= "${each.value.subnetCIDR}"
  enable_dhcp          = false
  no_gateway           = false
  dns_nameservers      = ["1.1.1.1","1.0.0.1"]
}

resource "openstack_networking_router_v2" "router" {
  for_each              = { for o in var.z : o.region => o }

  region		= "${each.key}"
  name                  = "${each.value.routerName}"
  admin_state_up        = true
  external_network_id   = "${data.openstack_networking_network_v2.Ext-Net[each.key].id}"
}

resource "openstack_networking_router_interface_v2" "routerInterface" {
  for_each              = { for o in var.z : o.region => o }

  region                = "${each.key}"
  router_id             = "${openstack_networking_router_v2.router[each.key].id}"
  subnet_id             = "${openstack_networking_subnet_v2.subnet[each.key].id}"
}

