output "floating_ip" {
  description = "Public floating IP attached to the active OPNsense node (follows CARP failover)"
  value       = module.opnsense_ha.floating_ip
}

output "webgui_url" {
  description = "OPNsense WebGUI URL (HTTPS on port 8443)"
  value       = "https://${module.opnsense_ha.floating_ip}:8443"
}

output "ssh_command" {
  description = "SSH command to connect to the active OPNsense node"
  value       = "ssh admin@${module.opnsense_ha.floating_ip}"
}

output "wan_carp_ip" {
  description = "WAN virtual IP (CARP VIP) — shared between primary and secondary"
  value       = module.opnsense_ha.wan_carp_ip
}

output "lan_carp_ip" {
  description = "LAN virtual IP (CARP VIP) — use this as the default gateway for workloads on the LAN"
  value       = module.opnsense_ha.lan_carp_ip
}

output "lan_cidr" {
  description = "LAN network CIDR"
  value       = module.opnsense_ha.lan_cidr
}

output "az_placement" {
  description = "Availability zone placement summary (null = single-AZ region, OpenStack decides)"
  value = {
    primary   = local.az_primary
    secondary = local.az_secondary
  }
}

output "api_key" {
  description = "OPNsense REST API key (use with api_secret for programmatic access)"
  value       = random_string.api_key.result
}

output "api_secret" {
  description = "OPNsense REST API secret (sensitive)"
  value       = random_password.api_secret.result
  sensitive   = true
}
