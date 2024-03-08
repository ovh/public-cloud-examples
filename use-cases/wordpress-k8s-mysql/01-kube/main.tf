# Create the Kubernetes Cluster
resource "ovh_cloud_project_kube" "wordpress_kube_cluster" {
  name               = "wordpress_kube_cluster"
  region             = var.kubernetes.region
  private_network_id = openstack_networking_network_v2.network.id
  private_network_configuration {
    default_vrack_gateway              = ""
    private_network_routing_as_default = true
  }
}

# Create the node-pool
resource "ovh_cloud_project_kube_nodepool" "wordpress_node_pool" {
  kube_id       = ovh_cloud_project_kube.wordpress_kube_cluster.id
  name          = "wordpress-node-pool" //Warning: "_" char is not allowed!
  flavor_name   = "b2-7"
  desired_nodes = 3
  max_nodes     = 3
  min_nodes     = 3
}

# Create a local file for the kubeconfig file
resource "local_file" "kubeconfig_file" {
  content  = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  filename = "kubeconfig_file"
}

# Retrieve info from nodes in the pool
data "ovh_cloud_project_kube_nodepool_nodes" "nodes" {
  kube_id = ovh_cloud_project_kube.wordpress_kube_cluster.id
  name    = ovh_cloud_project_kube_nodepool.wordpress_node_pool.name
}