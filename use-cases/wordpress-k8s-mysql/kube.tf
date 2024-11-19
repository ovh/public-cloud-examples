# Create the Kubernetes Cluster
resource "ovh_cloud_project_kube" "wordpress_kube_cluster" {
  name               = "${var.resource_prefix}kube_cluster"
  region             = var.kubernetes.region
  private_network_id = tolist(ovh_cloud_project_network_private.private_network.regions_attributes)[0].openstackid
  nodes_subnet_id = ovh_cloud_project_network_private_subnet.subnet.id
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
}

# Create a local file for the kubeconfig file
resource "local_file" "kubeconfig_file" {
  content  = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  filename = "kubeconfig.yml"
}