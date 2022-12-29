output "serviceName" {
  description = "Service Name"
  value       = var.serviceName
}

output "kubeClusterId" {
  description = "Kubernetes Cluster id"
  value       = ovh_cloud_project_kube.myKube.id
}

output "nodePoolId" {
  description = "Node Pool Id"
  value       = ovh_cloud_project_kube_nodepool.myPool.id
}
