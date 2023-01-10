resource "openstack_compute_instance_v2" "simple_instance" {
  name            = var.instance.name
  region          = var.instance.region
  flavor_name     = var.instance.flavor
  image_name      = var.instance.image
  key_pair        = var.instance.keypair_name
  security_groups = ["default"]

  network {
    name = var.instance.network_name
  }
}
