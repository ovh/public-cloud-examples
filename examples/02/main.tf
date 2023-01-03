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
