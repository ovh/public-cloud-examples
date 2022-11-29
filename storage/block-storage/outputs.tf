output "serviceName" {
 value = var.serviceName
}

output "volumeId" {
 value = openstack_blockstorage_volume_v3.bsVolume.id
}
