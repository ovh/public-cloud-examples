output "kubeconfig_file" {
  value     = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  sensitive = true
}

output "external_ip" {
  value = data.kubernetes_service.wordpress_svc.status.0.load_balancer.0.ingress.0.ip
}