output "hub_project_id" {
  value = ovh_cloud_project.hub.project_id
}

output "hub_vrack_service_name" {
  value = ovh_vrack.shared.service_name
}

output "hub_floating_ip" {
  value = module.hub.floating_ip
}

output "hub_wan_cidr" {
  value = module.hub.wan_cidr
}

output "hub_wan_carp_ip" {
  value = module.hub.wan_carp_ip
}

output "hub_lan_carp_ip" {
  value = module.hub.lan_carp_ip
}

output "ssh_hub" {
  value = "ssh admin@${module.hub.floating_ip}"
}

output "https_hub" {
  value = "https://${module.hub.floating_ip}:8443"
}

output "hub_api_key" {
  value     = random_string.hub_api_key.result
  sensitive = true
}

output "hub_api_secret" {
  value     = random_password.hub_api_secret.result
  sensitive = true
}
