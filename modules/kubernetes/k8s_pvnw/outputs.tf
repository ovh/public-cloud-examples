output "kubeconfig_file" {
  description = "kubeconfig file"
  value       = ovh_cloud_project_kube.kube.kubeconfig
}
