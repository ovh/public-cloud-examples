data "openstack_networking_network_v2" "myPrivateNetwork" {
  name   = var.pv_network_name
  region = var.region
}

data "openstack_networking_subnet_v2" "mySubnet" {
  name = var.subnet_name
}
