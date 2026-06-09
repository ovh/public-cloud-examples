output "spoke_project_id" {
  value = ovh_cloud_project.spoke.project_id
}

output "transit_router_ip" {
  description = "Spoke router IP on the transit VLAN (next-hop configured on the hub)"
  value       = module.spoke.transit_router_ip
}

output "spoke_subnet_cidrs" {
  description = "Spoke LAN subnet CIDRs"
  value       = module.spoke.subnet_cidrs
}

output "spoke_network_ids" {
  description = "Spoke LAN network IDs"
  value       = module.spoke.network_ids
}
