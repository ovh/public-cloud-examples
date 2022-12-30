resource "ovh_cloud_project_kube" "my_kube" {
  service_name = var.service_name
  name         = var.cluster_name
  region       = var.region

  private_network_id = data.openstack_networking_network_v2.myPrivateNetwork.id

  private_network_configuration {
    default_vrack_gateway              = var.rtr_ip
    private_network_routing_as_default = true
  }
}

resource "ovh_cloud_project_kube_nodepool" "my_pool" {
  service_name  = var.service_name
  kube_id       = ovh_cloud_project_kube.my_kube.id
  name          = var.my_pool_name
  flavor_name   = var.my_pool_flavor
  desired_nodes = var.my_pool_desired_nodes
  max_nodes     = var.my_pool_max_nodes
  min_nodes     = var.my_pool_min_nodes
}
