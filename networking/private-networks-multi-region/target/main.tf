resource "openstack_compute_instance_v2" "my_target" {
  name            = var.target.name
  region          = var.target.region
  flavor_name     = var.target.flavor
  image_name      = var.target.image
  key_pair        = var.keypair.name
  security_groups = ["default"]
  network {
    name = var.target.network_name
  }
}
