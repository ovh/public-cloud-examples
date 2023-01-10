output "floating_ip" {
  description = "Floating IP address"
  value       = openstack_networking_floatingip_v2.floatip.address
}
