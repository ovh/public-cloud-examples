data "openstack_networking_network_v2" "myPrivateNetwork" {
  name   = var.pvNetworkName
  region = var.region
}
