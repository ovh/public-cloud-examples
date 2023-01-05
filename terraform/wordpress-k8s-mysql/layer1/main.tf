# Create the Kubernetes Cluster
resource "ovh_cloud_project_kube" "wordpress_kube_cluster" {
   service_name = "${var.service_name}"
   name         = "wordpress_kube_cluster"
   region       = "${var.kubernetes.region}"
   version      = "1.24"
}

# Create the node-pool
resource "ovh_cloud_project_kube_nodepool" "wordpress_node_pool" {
   service_name  = "${var.service_name}"
   kube_id       = ovh_cloud_project_kube.wordpress_kube_cluster.id
   name          = "wordpress-node-pool" //Warning: "_" char is not allowed!
   flavor_name   = "b2-7"
   desired_nodes = 3
   max_nodes     = 3
   min_nodes     = 3
}

# Create a local file for the kubeconfig file
resource "local_file" "kubeconfig_file" {
  depends_on = [
    ovh_cloud_project_kube.wordpress_kube_cluster
  ]
  content  = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  filename = "kubeconfig_file"
}

# Retrieve info from nodes in the pool
data "ovh_cloud_project_kube_nodepool_nodes" "nodes" {
  depends_on = [
    ovh_cloud_project_kube_nodepool.wordpress_node_pool
  ]
  service_name  = ovh_cloud_project_kube.wordpress_kube_cluster.service_name
  kube_id       = ovh_cloud_project_kube.wordpress_kube_cluster.id
  name          = ovh_cloud_project_kube_nodepool.wordpress_node_pool.name
}