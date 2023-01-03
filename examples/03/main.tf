module "network" {
  source  = "../../modules/private_network"
  region  = var.region
  network = var.network
  subnet  = var.subnet
  router  = var.router
}

module "kube" {
  source  = "../../modules/kubernetes/k8s_pvnw"
  depends_on = [module.network]
  region  = var.region
  kube = var.kube
  pool = var.pool
}

resource "local_file" "kubeconfig_file" {
  depends_on = [ module.kube ]
  content  = module.kube.kubeconfig_file
  file_permission = "0644"
  filename = "kubeconfig_file"
}
