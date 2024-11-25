output "access_key_id" {
    value = module.s3_user.access_key_id
}

output "secret_access_key" {
    value = module.s3_user.secret_access_key
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

output "ovh_kube_cluster_kubeconfig" {
    value = module.kubeflow.ovh_kube_cluster_kubeconfig
    sensitive = true
}