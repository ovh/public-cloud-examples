output "service_name" {
  description = "Service Name"
  value       = var.service_name
}

output "myPrivateNetworkID" {
  description = "Private Network Id"
  value       = openstack_networking_network_v2.myPrivateNetwork.id
}

output "mySubnetID" {
  description = "Subnet Id"
  value       = openstack_networking_subnet_v2.mySubnet.id
}

output "Ext-NetID" {
  description = "External Network Id"
  value       = data.openstack_networking_network_v2.Ext-Net.id
}
