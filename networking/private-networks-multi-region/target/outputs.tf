output "target_private_ip" {
  description = "Target private IP"
  value       = openstack_compute_instance_v2.my_target.network[0].fixed_ip_v4
}
