data "openstack_networking_network_v2" "ext_net" {
  name     = "Ext-Net"
  external = true
}
resource "openstack_networking_network_v2" "network" {
  name = "private_network"
}


resource "openstack_networking_subnet_v2" "subnet" {
  name            = "subnet"
  network_id      = openstack_networking_network_v2.network.id
  cidr            = "10.0.0.0/24"
  gateway_ip      = "10.0.0.254"
  dns_nameservers = ["213.186.33.99"]
  ip_version      = 4
}

resource "openstack_networking_router_v2" "router" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "router_itf_priv" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}