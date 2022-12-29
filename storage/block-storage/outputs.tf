output "service_name" {
  description = "Service Name"
  value       = var.service_name
}

output "volume_id" {
  description = "Volume Id"
  value       = openstack_blockstorage_volume_v3.bs_volume.id
}
