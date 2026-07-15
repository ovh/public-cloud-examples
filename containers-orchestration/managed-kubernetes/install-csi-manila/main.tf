data "ovh_cloud_project_kube" "mks_cluster" {
  service_name = var.service_name
  kube_id      = var.mks_cluster_id
}

data "ovh_cloud_network_private_vrack_subnet" "mks_cluster_subnet" {
  service_name = var.service_name
  network_id   = data.ovh_cloud_project_kube.mks_cluster.private_network_id
  id           = data.ovh_cloud_project_kube.mks_cluster.nodes_subnet_id
}

# CSI Manila

module "csi_manila" {
  source     = "./modules/ovhcloud/csi_manila"

  service_name       = var.service_name
  region             = data.ovh_cloud_project_kube.mks_cluster.region
  share_network_name = "${data.ovh_cloud_project_kube.mks_cluster.name}-share-network"
  network_id         = data.ovh_cloud_project_kube.mks_cluster.private_network_id
  subnet_id          = data.ovh_cloud_project_kube.mks_cluster.nodes_subnet_id
  subnet_cidr        = data.ovh_cloud_network_private_vrack_subnet.mks_cluster_subnet.cidr
}

output "manila-user" {
  value = module.csi_manila.manila-user
}
