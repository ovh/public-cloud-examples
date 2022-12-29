resource "openstack_networking_network_v2" "myPrivateNetwork" {
  name           = var.pvNetworkName
  admin_state_up = "true"
  region         = var.region
}

resource "openstack_networking_subnet_v2" "mySubnet" {
  network_id      = openstack_networking_network_v2.myPrivateNetwork.id
  name            = var.subnetName
  region          = var.region
  cidr            = var.subnetCIDR
  enable_dhcp     = true
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]

  allocation_pool {
    start = var.subnetDHCPStart
    end   = var.subnetDHCPEnd
  }
}

resource "openstack_networking_router_v2" "myRouter" {
  name                = var.rtrName
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.Ext-Net.id
  region              = var.region
}

resource "openstack_networking_router_interface_v2" "myRouterInterface" {
  router_id = openstack_networking_router_v2.myRouter.id
  subnet_id = openstack_networking_subnet_v2.mySubnet.id
  region    = var.region
}
