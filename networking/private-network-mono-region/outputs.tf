output "serviceName" {
  value = var.serviceName
}

output "myPrivateNetworkID" {
  value = openstack_networking_network_v2.myPrivateNetwork.id
}

output "mySubnetID" {
  value = openstack_networking_subnet_v2.mySubnet.id
}

output "Ext-NetID" {
  value = data.openstack_networking_network_v2.Ext-Net.id
}
