data "openstack_networking_network_v2" "Ext-Net" {
  name   = "Ext-Net"
  region = var.region
}
