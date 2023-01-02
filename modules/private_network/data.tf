data "openstack_networking_network_v2" "ext_net" {
  name   = "Ext-Net"
  region = var.region
}
