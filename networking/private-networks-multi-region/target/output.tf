output "target_private_IP" {
  value = openstack_compute_instance_v2.myTarget.network[0].fixed_ip_v4
}
