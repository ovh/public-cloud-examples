
output "kubeflow_url" {
  description = "Kubeflow URL"
  value = module.kubeflow.kubeflow_url
  //value = "https://kubeflow.${var.ovh_dns_domain}"
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