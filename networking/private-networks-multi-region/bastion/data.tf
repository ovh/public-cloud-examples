data "template_file" "ssh_config_tpl" {
  template = file("${path.module}/ssh_config.tpl")
  vars = {
    bastionName = var.bastion.bastionName
    bastionIP   = openstack_compute_instance_v2.myBastion.network[0].fixed_ip_v4
    bastionUser = var.bastion.bastionUser
    keypairName = var.keypair.keypairName
  }
}

data "template_file" "user-data-bastion_tpl" {
  template = file("${path.module}/user-data-bastion.sh.tpl")
  vars = {
    bastionIP  = var.bastion.bastionIP
    subnetCIDR = var.bastion.bSubnetCIDR
    rtrIp      = var.bastion.bRtrIp
  }
}
