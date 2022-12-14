data "template_file" "ssh_config_tpl" {
  template = file("${path.module}/ssh_config.tpl")
  vars = {
    targetName  = var.target.name
    targetIP    = openstack_compute_instance_v2.myTarget.network[0].fixed_ip_v4
    targetUser  = var.target.user
    keypairName = var.keypair.keypairName
  }
}

data "template_file" "user-data-target_tpl" {
  template = file("${path.module}/user-data-target.sh.tpl")
  vars = {
    targetIP        = var.target.fixedIP
    rtrIp           = var.target.rtrIp
    subnetMultiCIDR = var.target.subnetMultiCIDR
  }
}
