output "hub_project_id" {
  value = ovh_cloud_project.hub.project_id
}

output "spoke_qa_project_id" {
  value = ovh_cloud_project.spoke_qa.project_id
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

output "spoke_qa_floating_ip" {
  value = module.spoke_qa.floating_ip
}

output "ssh_hub" {
  value = "ssh admin@${module.hub.floating_ip}"
}

output "https_hub" {
  value = "https://${module.hub.floating_ip}:8443"
}

output "ssh_spoke_qa" {
  value = "ssh admin@${module.spoke_qa.floating_ip}"
}

output "https_spoke_qa" {
  value = "https://${module.spoke_qa.floating_ip}:8443"
}

