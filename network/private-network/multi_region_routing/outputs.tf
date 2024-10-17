output "client_instance_region1_fip" {
  value       = openstack_networking_floatingip_v2.fip1.address
  description = "Instance client region 1 Floating IP"
}

output "client_instance_region1_private_ip" {
  value       = openstack_compute_instance_v2.instance_client_region1.access_ip_v4
  description = "Instance client region 1 private IP"
}


output "server_instance_region1_private_ip" {
  value       = openstack_compute_instance_v2.instance_server_region1.access_ip_v4
  description = "Instance server region 1 private IP"
}

output "server_instance_region2_fip" {
  value       = openstack_networking_floatingip_v2.fip2.address
  description = "Instance server region 2 Floating IP"
}

output "server_instance_region2_private_ip" {
  value       = openstack_compute_instance_v2.instance_server_region2.access_ip_v4
  description = "Instance server region 2 private IP"
}


