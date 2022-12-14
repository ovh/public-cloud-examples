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

module "routes" {
  source = "./routes"
  depends_on = [
    module.mynetwork
  ]
  routes = var.routes
}

module "mybastion" {
  source = "./bastion"
  depends_on = [
    module.routes,
    module.mykeypair
  ]
  serviceName = var.serviceName
  bastion     = var.bastion
  keypair     = var.keypair
}

module "mytarget" {
  source = "./target"
  depends_on = [
    module.routes,
    module.mykeypair
  ]
  target  = var.target
  keypair = var.keypair
}
