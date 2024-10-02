output "ovh_kube_cluster_kubeconfig" {
  description = "OVHcloud MKS cluster kubeconfig"
  value = ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig
  sensitive = true
}

output "kubeflow_url" {
  description = "Kubeflow URL"
  value = "https://kubeflow.${var.ovh_dns_domain}"
}

output "kubeflow_user" {
  description = "Kubeflow default user"
  value = "user@${var.ovh_dns_domain}"
}

output "kubeflow_password" {
  description = "Kubeflow default user password"
  value = "ovhkubeflow123!"
  sensitive = true
}