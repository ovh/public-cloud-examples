resource "openstack_compute_instance_v2" "myBack" {
  name            = var.back.backName
  region          = var.back.bRegion
  flavor_name     = var.back.backFlavor
  image_name      = var.back.backImage
  key_pair        = var.keypair.keypairName
  security_groups = ["default"]
  user_data       = data.template_file.user-data-back_tpl.rendered

  network {
    name        = var.back.backNwName
    fixed_ip_v4 = var.back.backIP
  }
}
