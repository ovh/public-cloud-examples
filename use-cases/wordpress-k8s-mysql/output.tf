output "kubeconfig_file" {
  value     = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  sensitive = true
}
