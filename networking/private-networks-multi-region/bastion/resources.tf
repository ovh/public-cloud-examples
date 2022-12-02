resource "openstack_compute_keypair_v2" "myKeypair" {
  region = var.bastion.bRegion
  name   = var.keypair.keypairName
}

resource "local_file" "ssh_private_key" {
  content         = openstack_compute_keypair_v2.myKeypair.private_key
  filename        = "${path.module}/${var.keypair.keypairName}_rsa"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content         = openstack_compute_keypair_v2.myKeypair.public_key
  filename        = "${path.module}/${var.keypair.keypairName}_rsa.pub"
  file_permission = "0644"
}

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
