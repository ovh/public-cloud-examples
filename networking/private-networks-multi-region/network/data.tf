data "openstack_networking_network_v2" "Ext-Net" {
  for_each = { for o in var.multi : o.region => o }

  name   = "Ext-Net"
  region = each.key
}
