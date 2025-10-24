output "rancher_url" {
  value = ovh_cloud_project_rancher.rancher.current_state.url
}

output "rancher_password" {
  value = ovh_cloud_project_rancher.rancher.current_state.bootstrap_password
  sensitive = true
}

output "rancher_egress_cidr" {
  value = ovh_cloud_project_rancher.rancher.current_state.networking.egress_cidr_blocks
}