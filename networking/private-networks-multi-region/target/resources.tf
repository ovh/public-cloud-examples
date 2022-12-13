resource "openstack_compute_instance_v2" "myTarget" {
  name            = var.target.targetName
  region          = var.target.bRegion
  flavor_name     = var.target.targetFlavor
  image_name      = var.target.targetImage
  key_pair        = var.keypair.keypairName
  security_groups = ["default"]
  user_data       = data.template_file.user-data-target_tpl.rendered

  lifecycle { ignore_changes = ["user_data"] }

  network {
    name = "Ext-Net"
  }

  network {
    name        = var.target.frontNwName
    fixed_ip_v4 = var.target.targetIP
  }
}

resource "local_file" "ssh_config" {
  content         = data.template_file.ssh_config_tpl.rendered
  filename        = "${path.module}/${var.keypair.keypairName}_ssh_config"
  file_permission = "0644"
}
