output "my_private_network_id" {
  description = "Private Network Id"
  value       = openstack_networking_network_v2.my_private_network.id
}

output "my_subnet_id" {
  description = "Subnet Id"
  value       = openstack_networking_subnet_v2.my_subnet.id
}

output "ext_net_id" {
  description = "External Network Id"
  value       = data.openstack_networking_network_v2.ext_net.id
}
