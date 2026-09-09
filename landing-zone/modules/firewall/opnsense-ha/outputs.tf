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

output "primary_wan_ip" {
  value = openstack_networking_port_v2.fw_wan_active_port.fixed_ip[0].ip_address
}

output "secondary_wan_ip" {
  value = openstack_networking_port_v2.fw_wan_passive_port.fixed_ip[0].ip_address
}

output "router_id" {
  description = "Neutron router (OVHcloud Gateway) attached to the WAN subnet"
  value       = openstack_networking_router_v2.fw_wan_router.id
}

output "image_source_url" {
  value = local.image_source_url
}

output "ssh_private_key" {
  description = "Auto-generated SSH private key (empty when ssh_public_key_path is provided)"
  value       = openstack_compute_keypair_v2.fw_keypair.private_key
  sensitive   = true
}

output "proxy_ssl_ports" {
  description = "Rendered squid SSL_ports list (CONNECT targets) derived from proxy_connect_ports; fed to tools/hub-postboot.sh so a change applies to running nodes."
  value       = local.template_common.PROXY_SSL_PORTS
}

output "proxy_whitelist" {
  description = "Rendered squid url_regex allowlist (comma-separated) derived from proxy_allowed_domains; empty when the proxy accepts any destination. Fed to tools/hub-postboot.sh so a change applies to running nodes."
  value       = local.template_common.PROXY_ALLOWED_DOMAINS
}
