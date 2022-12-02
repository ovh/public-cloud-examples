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

/*
module "myback" {
  source = "./back"
  depends_on = [
    module.mynetwork,
    module.mykeypair
  ]
  serviceName = var.serviceName
  back        = var.back
  keypair     = var.keypair
}
*/
