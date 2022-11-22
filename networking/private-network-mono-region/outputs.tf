output "serviceName" {
 value = var.serviceName
}

output "myPrivateNetworkID" {
  value = tolist(ovh_cloud_project_network_private.myPrivateNetwork.regions_attributes)[0].openstackid
}

output "mySubnetID" {
  value = openstack_networking_subnet_v2.mySubnet.id
}

output "Ext-NetID" {
  value = openstack_networking_network_v2.Ext-Net.id
}
