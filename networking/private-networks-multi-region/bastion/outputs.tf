output "bastion_private_ip" {
  description = "Bastion private IP"
  value       = openstack_compute_instance_v2.my_bastion.network[0].fixed_ip_v4
}

output "floating_ip" {
  description = "Bastion public IP (floating IP)"
  value       = openstack_networking_floatingip_v2.floatip_bastion.address
}
