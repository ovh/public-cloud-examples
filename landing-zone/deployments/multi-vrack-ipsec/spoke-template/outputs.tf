output "spoke_project_id" {
  value = ovh_cloud_project.spoke.project_id
}

output "spoke_floating_ip" {
  value = module.spoke.floating_ip
}

output "https_spoke" {
  value = "https://${module.spoke.floating_ip}:8443"
}

