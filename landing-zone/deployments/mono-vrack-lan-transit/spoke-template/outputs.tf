output "spoke_project_id" {
  value = ovh_cloud_project.spoke.project_id
}
output "slot" {
  value = module.spoke.slot
}
output "supernet" {
  value = module.spoke.supernet
}
output "transit_ip" {
  description = "Spoke router address on the transit VLAN (already routed by the hub)"
  value       = module.spoke.transit_ip
}
output "lans" {
  value = module.spoke.lans
}
output "security_groups" {
  value = { base = module.spoke.secgroup_base_id, intra = module.spoke.secgroup_intra_id }
}
output "team_openrc" {
  description = "Hand this to the workload team (compute-only identity)"
  sensitive   = true
  value = {
    OS_AUTH_URL         = "https://auth.cloud.ovh.net/v3/"
    OS_PROJECT_ID       = ovh_cloud_project.spoke.project_id
    OS_USER_DOMAIN_NAME = "Default"
    OS_USERNAME         = ovh_cloud_project_user.spoke_team.username
    OS_PASSWORD         = ovh_cloud_project_user.spoke_team.password
    OS_REGION_NAME      = var.compute_region
    HTTP_PROXY          = "http://${var.hub_lan_carp_ip}:3128"
  }
}
output "audit_openrc" {
  sensitive = true
  value = {
    OS_PROJECT_ID  = ovh_cloud_project.spoke.project_id
    OS_USERNAME    = ovh_cloud_project_user.spoke_audit.username
    OS_PASSWORD    = ovh_cloud_project_user.spoke_audit.password
    OS_REGION_NAME = var.compute_region
  }
}
