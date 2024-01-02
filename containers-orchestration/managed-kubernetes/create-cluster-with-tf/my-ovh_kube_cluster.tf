resource "ovh_cloud_project_kube" "my_kube_cluster" {
   name         = "my_kube_cluster-demo"
   region       = "GRA7"
}

resource "ovh_cloud_project_kube_nodepool" "node_pool" {
   kube_id       = ovh_cloud_project_kube.my_kube_cluster.id
   name          = "my-pool"
   flavor_name   = "b2-7"
   desired_nodes = 3
   max_nodes     = 3
   min_nodes     = 1
}