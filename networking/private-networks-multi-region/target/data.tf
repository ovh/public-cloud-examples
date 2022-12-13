data "template_file" "ssh_config_tpl" {
  template = file("${path.module}/ssh_config.tpl")
  vars = {
    targetName  = var.target.targetName
    targetIP    = openstack_compute_instance_v2.myTarget.network[0].fixed_ip_v4
    targetUser  = var.target.targetUser
    keypairName = var.keypair.keypairName
  }
}

data "template_file" "user-data-target_tpl" {
  template = file("${path.module}/user-data-target.sh.tpl")
  vars = {
    targetIP       = var.target.targetIP
    subnetCIDR     = var.target.bSubnetCIDR
    rtrIp          = var.target.bRtrIp
    backSubnetCIDR = var.target.backSubnetCIDR
    bGateway       = var.target.bGateway
  }
}
