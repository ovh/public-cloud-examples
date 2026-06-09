output "router_id" {
  description = "Spoke Neutron router ID"
  value       = openstack_networking_router_v2.spoke.id
}

output "transit_router_ip" {
  description = "Spoke router IP on the transit VLAN (next-hop to configure on the hub)"
  value       = var.transit_router_ip
}

output "network_ids" {
  description = "Map of spoke LAN network IDs"
  value       = { for k, v in openstack_networking_network_v2.spoke_lans : k => v.id }
}

output "subnet_cidrs" {
  description = "Map of spoke LAN subnet CIDRs"
  value       = { for k, v in var.networks : k => v.cidr }
}
