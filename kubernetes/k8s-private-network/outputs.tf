output "serviceName" {
 value = var.serviceName
}

output "kubeClusterId" {
 value = ovh_cloud_project_kube.myKube.id
}

output "nodePoolId" {
 value = ovh_cloud_project_kube_nodepool.myPool.id
}
