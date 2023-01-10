output "instance_id" {
  description = "Instance Id"
  value       = openstack_compute_instance_v2.simple_instance.id
}

output "instance_private_ip" {
  description = "Instance private IP"
  value       = openstack_compute_instance_v2.simple_instance.network[0].fixed_ip_v4
}
