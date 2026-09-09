output "hub_project_id" {
  value = ovh_cloud_project.hub.project_id
}
output "hub_vrack_service_name" {
  description = "vRack delivered with the hub — every spoke joins it at order time"
  value       = data.ovh_cloud_project_vrack.hub.id
}
output "hub_floating_ip" {
  value = module.hub.floating_ip
}
output "hub_lan_carp_ip" {
  description = "Hub LAN CARP VIP: default gateway of the spoke routers, DNS/NTP/proxy address for the workloads"
  value       = module.hub.lan_carp_ip
}
output "https_hub" {
  value = "https://${module.hub.floating_ip}:8443"
}
output "ssh_hub" {
  value = "ssh admin@${module.hub.floating_ip}"
}
output "hub_api_key" {
  value = random_string.hub_api_key.result
}
output "hub_api_secret" {
  value     = random_password.hub_api_secret.result
  sensitive = true
}

# Copy these into every spoke's terraform.tfvars
output "spoke_inputs" {
  description = "Hub facts a Day-2 spoke needs"
  value = {
    hub_vrack_service_name = data.ovh_cloud_project_vrack.hub.id
    hub_lan_vlan_id        = var.hub_net_lan_vlan_id
    hub_lan_cidr           = var.hub_private_lan_cidr
    hub_lan_carp_ip        = module.hub.lan_carp_ip
    slot_count             = var.slot_count
    compute_region         = var.compute_region
  }
}
