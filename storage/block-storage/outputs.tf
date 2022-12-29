output "serviceName" {
  description = "Service Name"
  value       = var.serviceName
}

output "volumeId" {
  description = "Volume Id"
  value       = openstack_blockstorage_volume_v3.bsVolume.id
}
