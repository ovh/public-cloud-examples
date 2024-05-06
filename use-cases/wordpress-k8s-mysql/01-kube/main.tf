# Create the Kubernetes Cluster
resource "ovh_cloud_project_kube" "wordpress_kube_cluster" {
  name               = "${var.resource_prefix}kube_cluster"
  region             = var.kubernetes.region
  private_network_id = tolist(ovh_cloud_project_network_private.private_network.regions_attributes)[0].openstackid
  private_network_configuration {
    default_vrack_gateway              = ""
    private_network_routing_as_default = true
  }
}

# Create the node-pool
resource "ovh_cloud_project_kube_nodepool" "wordpress_node_pool" {
  kube_id       = ovh_cloud_project_kube.wordpress_kube_cluster.id
  name          = "${var.resource_prefix}node-pool" //Warning: "_" char is not allowed!
  flavor_name   = var.node_pool_flavor_name
  desired_nodes = 3
  max_nodes     = 3
  min_nodes     = 3
  depends_on = [
    ovh_cloud_project_network_private_subnet.subnet
  ]
}

# Create a local file for the kubeconfig file
resource "local_file" "kubeconfig_file" {
  content  = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  filename = "kubeconfig.yml"
}

# Retrieve info from nodes in the pool
data "ovh_cloud_project_kube_nodepool_nodes" "nodes" {
  kube_id = ovh_cloud_project_kube.wordpress_kube_cluster.id
  name    = ovh_cloud_project_kube_nodepool.wordpress_node_pool.name
}