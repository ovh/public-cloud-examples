module "mykeypair" {
  source  = "./keypair"
  keypair = var.keypair
}

module "mynetwork" {
  source      = "./network"
  serviceName = var.serviceName
  common      = var.common
  multi       = var.multi
}

/*
module "mybastion" {
  source = "./bastion"
  depends_on = [
    module.mynetwork,
    module.mykeypair
  ]
  serviceName = var.serviceName
  bastion     = var.bastion
  keypair     = var.keypair
}

module "mytarget" {
  source = "./target"
  depends_on = [
    module.mynetwork,
    module.mykeypair
  ]
  serviceName = var.serviceName
  target      = var.target
  keypair     = var.keypair
}
*/
