output "kubeconfig" {
  value = ovh_cloud_project_kube.my_kube_cluster.kubeconfig
  sensitive = true
}