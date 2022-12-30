data "openstack_networking_network_v2" "my_private_network" {
  name   = var.pv_network_name
  region = var.region
}

data "openstack_networking_subnet_v2" "my_subnet" {
  name = var.subnet_name
}
