module "network" {
  source  = "../../modules/private_network"
  region  = var.region
  network = var.network
  subnet  = var.subnet
  router  = var.router
}

module "db_engine" {
  source     = "../../modules/database/mongodb_pvnw"
  depends_on = [module.network]
  region     = var.region
  db_engine  = var.db_engine
}

module "keypair" {
  source  = "../../modules/ssh_keypair"
  keypair = var.keypair
}

module "instance" {
  source     = "../../modules/instance_simple"
  depends_on = [module.keypair, module.network]
  instance   = var.instance
}

module "floatip" {
  source     = "../../modules/floating_ip"
  depends_on = [module.instance]
  floatip = {
    region       = var.region
    component_id = module.instance.instance_id
  }
}
