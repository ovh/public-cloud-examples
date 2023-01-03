output "service_name" {
  description = "Service Name"
  value       = var.service_name
}

output "kube_cluster_id" {
  description = "Kubernetes Cluster id"
  value       = ovh_cloud_project_kube.my_kube.id
}

output "node_pool_id" {
  description = "Node Pool Id"
  value       = ovh_cloud_project_kube_nodepool.my_pool.id
}
