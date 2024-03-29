data "openstack_networking_network_v2" "private_network" {
  name   = var.db_engine.pv_network_name
  region = var.region
}

data "openstack_networking_subnet_v2" "subnet" {
  name   = var.db_engine.subnet_name
  region = var.region
}
