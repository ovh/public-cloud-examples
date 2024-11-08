output "ovh_kube_cluster_kubeconfig" {
  description = "OVHcloud MKS cluster kubeconfig"
  value = ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig
  sensitive = true
}