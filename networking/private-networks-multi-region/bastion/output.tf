output "bastion_private_IP" {
  value = openstack_compute_instance_v2.myBastion.network[0].fixed_ip_v4
}

output "floating_IP" {
  value = openstack_networking_floatingip_v2.floatip_bastion.address
}
