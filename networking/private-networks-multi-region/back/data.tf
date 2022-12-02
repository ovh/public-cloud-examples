data "template_file" "user-data-back_tpl" {
  template = file("${path.module}/user-data-back.sh.tpl")
  vars = {
    backIP     = var.back.backIP
    subnetCIDR = var.back.bSubnetCIDR
    rtrIp      = var.back.bRtrIp
  }
}
