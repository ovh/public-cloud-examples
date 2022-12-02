resource "openstack_compute_instance_v2" "myBastion" {
  name            = var.bastion.bastionName
  region          = var.bastion.bRegion
  flavor_name     = var.bastion.bastionFlavor
  image_name      = var.bastion.bastionImage
  key_pair        = var.keypair.keypairName
  security_groups = ["default"]
  user_data       = data.template_file.user-data-bastion_tpl.rendered

  network {
    name = "Ext-Net"
  }

  network {
    name        = var.bastion.frontNwName
    fixed_ip_v4 = var.bastion.bastionIP
  }
}

resource "local_file" "ssh_config" {
  content         = data.template_file.ssh_config_tpl.rendered
  filename        = "${path.module}/${var.keypair.keypairName}_ssh_config"
  file_permission = "0644"
}
