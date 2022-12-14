resource "openstack_compute_instance_v2" "myBastion" {
  name            = var.bastion.name
  region          = var.bastion.region
  flavor_name     = var.bastion.flavor
  image_name      = var.bastion.image
  key_pair        = var.keypair.keypairName
  security_groups = ["default"]
  user_data       = data.template_file.user-data-bastion_tpl.rendered

  lifecycle { ignore_changes = [user_data] }

  network {
    name = "Ext-Net"
  }

  network {
    name        = var.bastion.networkName
    fixed_ip_v4 = var.bastion.fixedIP
  }
}

resource "local_file" "ssh_config" {
  content         = data.template_file.ssh_config_tpl.rendered
  filename        = "${path.module}/${var.keypair.keypairName}_ssh_config"
  file_permission = "0644"
}
