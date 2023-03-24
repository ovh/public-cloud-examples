output "kubeconfig_file" {
  description = "kubeconfig file"
  value       = ovh_cloud_project_kube.kube.kubeconfig
}

output "mycluster-host" {
  description = "Kubernetes Cluster Host"
  value       = ovh_cloud_project_kube.kube.kubeconfig_attributes[0].host
  sensitive   = true
}

output "mycluster-cluster-ca-certificate" {
  description = "Kubernetes Cluster CA Certificate"
  value       = ovh_cloud_project_kube.kube.kubeconfig_attributes[0].cluster_ca_certificate
  sensitive   = true
}

output "mycluster-client-certificate" {
  description = "Kubernetes Cluster Client Certificate"
  value       = ovh_cloud_project_kube.kube.kubeconfig_attributes[0].client_certificate
  sensitive   = true
}

output "mycluster-client-key" {
  description = "Kubernetes Cluster Client Key"
  value       = ovh_cloud_project_kube.kube.kubeconfig_attributes[0].client_key
  sensitive   = true
}

output "mycluster-current-context" {
  description = "Kubernetes Cluster Current Context"
  value       = join("@",["kubernetes-admin",ovh_cloud_project_kube.kube.name])
}
