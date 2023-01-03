module "network" {
  source  = "../../modules/private_network"
  region  = var.region
  network = var.network
  subnet  = var.subnet
  router  = var.router
}

module "kube" {
  source     = "../../modules/kubernetes/k8s_pvnw"
  depends_on = [module.network]
  region     = var.region
  kube       = var.kube
  pool       = var.pool
}

resource "local_file" "kubeconfig_file" {
  depends_on      = [module.kube]
  content         = module.kube.kubeconfig_file
  file_permission = "0644"
  filename        = "kubeconfig_file"
}

module "mysql" {
  source     = "../../modules/database/mysql_pvnw"
  depends_on = [module.network]
  region     = var.region
  db_engine  = var.db_engine
  db         = var.db
}

# Create the wordpress web site and connect it to the DB
resource "helm_release" "wordpress" {
  depends_on = [module.mysql, local_file.kubeconfig_file]
  name       = "wordpress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "wordpress"

  set {
    name  = "mariadb.enabled"
    value = "false"
  }
  set {
    name  = "externalDatabase.host"
    value = module.mysql.db_host
  }
  set {
    name  = "externalDatabase.port"
    value = module.mysql.db_port
  }
  set {
    name  = "externalDatabase.user"
    value = module.mysql.user_name
  }
  set {
    name  = "externalDatabase.password"
    value = module.mysql.user_password
  }
  set {
    name  = "externalDatabase.database"
    value = module.mysql.db_name
  }
}
