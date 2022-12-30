resource "openstack_compute_instance_v2" "my_bastion" {
  name            = var.bastion.name
  region          = var.bastion.region
  flavor_name     = var.bastion.flavor
  image_name      = var.bastion.image
  key_pair        = var.keypair.name
  security_groups = ["default"]

  network {
    name = var.bastion.network_name
  }
}

resource "openstack_networking_floatingip_v2" "floatip_bastion" {
  region = var.bastion.region
  pool   = "Ext-Net"
}

resource "openstack_compute_floatingip_associate_v2" "fip_associate_bastion" {
  region      = var.bastion.region
  floating_ip = openstack_networking_floatingip_v2.floatip_bastion.address
  instance_id = openstack_compute_instance_v2.my_bastion.id
}
