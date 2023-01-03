resource "ovh_cloud_project_kube" "kube" {
  name   = var.kube.name
  region = var.region

  private_network_id = data.openstack_networking_network_v2.my_private_network.id

  private_network_configuration {
    default_vrack_gateway              = var.kube.gateway_ip
    private_network_routing_as_default = true
  }
}

resource "ovh_cloud_project_kube_nodepool" "my_pool" {
  kube_id       = ovh_cloud_project_kube.kube.id
  name          = var.pool.name
  flavor_name   = var.pool.flavor
  desired_nodes = var.pool.desired_nodes
  max_nodes     = var.pool.max_nodes
  min_nodes     = var.pool.min_nodes
}
