resource "ovh_cloud_project_kube" "myKube" {
    service_name  = var.serviceName
    name          = var.clusterName
    region        = var.region

    private_network_id = data.openstack_networking_network_v2.myPrivateNetwork.id

    private_network_configuration {
        default_vrack_gateway              = var.rtrIp
        private_network_routing_as_default = true
    }
}

resource "ovh_cloud_project_kube_nodepool" "myPool" {
  service_name  = var.serviceName
  kube_id       = ovh_cloud_project_kube.myKube.id
  name          = var.myPoolName 
  flavor_name   = var.myPoolFlavor
  desired_nodes = var.myPoolDesiredNodes
  max_nodes     = var.myPoolMaxNodes
  min_nodes     = var.myPoolMinNodes
}
