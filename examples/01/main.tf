module "network" {
  source  = "../../modules/private_network"
  region  = var.region
  network = var.network
  subnet  = var.subnet
  router  = var.router
}

module "keypair" {
  source  = "../../modules/ssh_keypair"
  keypair = var.keypair
}

module "bastion" {
  source     = "../../modules/instance_simple"
  depends_on = [module.keypair, module.network]
  instance   = var.bastion
}

module "floatip" {
  source     = "../../modules/floating_ip"
  depends_on = [module.bastion]
  floatip = {
    region       = var.region
    component_id = module.bastion.instance_id
  }
}
