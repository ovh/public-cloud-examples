output "kubeconfig_file" {
  value = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  sensitive = true
}

output "nodepool_nodes" {
  value = data.ovh_cloud_project_kube_nodepool_nodes.nodes
}