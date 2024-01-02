resource "openstack_networking_floatingip_v2" "floatip" {
  region = var.floatip.region
  pool   = "Ext-Net"
}

resource "openstack_compute_floatingip_associate_v2" "floatip_association" {
  region      = var.floatip.region
  floating_ip = openstack_networking_floatingip_v2.floatip.address
  instance_id = var.floatip.component_id
}
