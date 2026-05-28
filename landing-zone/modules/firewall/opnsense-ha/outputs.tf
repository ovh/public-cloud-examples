output "floating_ip" {
  value = openstack_networking_floatingip_v2.fw_fip.address
}

output "wan_carp_ip" {
  value = openstack_networking_port_v2.fw_wan_carp_vip.fixed_ip[0].ip_address
}

output "lan_carp_ip" {
  value = openstack_networking_port_v2.fw_lan_carp_vip.fixed_ip[0].ip_address
}

output "wan_cidr" {
  value = var.private_wan_cidr
}

output "lan_cidr" {
  value = var.private_lan_cidr
}
