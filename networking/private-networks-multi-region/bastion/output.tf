output "bastion_public_IP" {
  value = openstack_compute_instance_v2.myBastion.network[0].fixed_ip_v4
}
