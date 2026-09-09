variable "os_tenant_id" {
  description = "DEPRECATED — no longer used. The module only needs OpenStack credentials (OS_* environment variables). Kept for backward compatibility with existing callers."
  type        = string
  default     = null
}

variable "os_region" {
  description = "OpenStack region (e.g. GRA9, GRA11, SBG7, BHS5, EU-WEST-PAR)"
  type        = string
}

variable "az_primary" {
  description = "Availability zone for the primary (active) instance. Set for 3-AZ regions (eu-west-par-a/b/c, eu-south-mil-a/b/c). Leave null for single-AZ regions."
  type        = string
  default     = null
}

variable "az_secondary" {
  description = "Availability zone for the secondary (passive) instance. Must differ from az_primary in 3-AZ regions."
  type        = string
  default     = null
}

variable "os_instance_flavor_name" {
  description = "OPNsense instance flavor name"
  type        = string
  default     = "b3-16"
}

variable "ssh_public_key_path" {
  description = "Path to an SSH public key file. If null, a keypair is auto-generated (private key exposed by the ssh_private_key output)."
  type        = string
  default     = null
}

variable "opnsense_version" {
  description = "OPNsense release of the cloud-ready image (see docs/04-image-opnsense-cloud-ready.md). The XML templates target the 26.7 configuration model."
  type        = string
  default     = "26.7"
}

variable "image_source_url" {
  description = "Full URL of the cloud-ready qcow2 to import into Glance. Defaults to the public OVHcloud S3 bucket for opnsense_version."
  type        = string
  default     = null
}

variable "admin_client_ip" {
  description = "IP address or CIDR allowed to manage the firewall (WebGUI 8443, SSH 22). Stored in the AdminClients alias."
  type        = string
}

variable "admin_password" {
  description = "Firewall admin password (root and admin accounts)"
  type        = string
  sensitive   = true
}

variable "ha_password" {
  description = "Shared secret for CARP advertisements and xmlrpc config synchronisation (haadmin account)"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "OPNsense API key (injected into config.xml for REST API auth)"
  type        = string
  sensitive   = true
  default     = null
}

variable "api_secret_hash" {
  description = "OPNsense API secret bcrypt hash"
  type        = string
  sensitive   = true
  default     = null
}

variable "net_wan_vlan_id" {
  description = "VLAN ID of the WAN network"
  type        = number
  default     = 100
}

variable "private_wan_cidr" {
  description = "CIDR of the WAN network"
  type        = string
  default     = "10.1.0.0/24"
}

variable "net_lan_vlan_id" {
  description = "VLAN ID of the LAN network"
  type        = number
  default     = 200
}

variable "private_lan_cidr" {
  description = "CIDR of the LAN network"
  type        = string
  default     = "192.168.10.0/24"
}

variable "net_hasync_vlan_id" {
  description = "VLAN ID of the HA sync network"
  type        = number
  default     = 199
}

variable "private_hasync_cidr" {
  description = "CIDR of the HA sync network"
  type        = string
  default     = "10.0.254.0/30"
}

variable "role" {
  description = "OPNsense configuration role. Selects the XML template set to inject. hub-simple is the maintained 26.7 template (standalone or hub with slots/services). hub-ipsec and spoke-ipsec are DEPRECATED: legacy rules and pre-26.7 HA layout (CARP only)."
  type        = string
  default     = "hub-simple"
  validation {
    condition     = contains(["hub-simple", "hub-ipsec", "spoke-ipsec"], var.role)
    error_message = "role must be one of: hub-simple, hub-ipsec, spoke-ipsec."
  }
}

variable "template_extra_vars" {
  description = "Additional template variables merged into the base set (e.g. IPsec parameters for hub-ipsec and spoke-ipsec roles)"
  type        = map(string)
  default     = {}
}

########################################################################################
#   Hub role: slot-based spoke routing + zero-trust services (DNS / NTP / explicit proxy)
#   All disabled by default so the standalone deployment keeps its current behaviour.
########################################################################################

variable "slot_count" {
  description = "Number of spoke slots pre-provisioned on the hub (OPNsense gateway + static route per slot, no OVH resource). 0 disables slot routing."
  type        = number
  default     = 0
  validation {
    condition     = var.slot_count >= 0 && var.slot_count <= 200
    error_message = "slot_count must be between 0 and 200."
  }
}

variable "slot_supernet_base" {
  description = "Base network carved into one /16 per slot: slot k gets cidrsubnet(base, 8, k) (10.0.0.0/8 -> 10.k.0.0/16)."
  type        = string
  default     = "10.0.0.0/8"
}

variable "slot_transit_offset" {
  description = "Slot k's Neutron router takes cidrhost(private_lan_cidr, offset + k) on the transit VLAN (must stay outside the hub DHCP pool .100-.200)."
  type        = number
  default     = 10
}

variable "proxy_allowed_domains" {
  description = "With hub_services: restrict the explicit proxy to these destination domain suffixes (squid allowlist, e.g. [\"ubuntu.com\", \"docker.io\"]); a suffix matches the domain and its sub-domains. Empty = any destination. Requests are logged either way."
  type        = list(string)
  default     = []
  validation {
    condition     = alltrue([for d in var.proxy_allowed_domains : can(regex("^[A-Za-z0-9.-]+$", d))])
    error_message = "proxy_allowed_domains entries must be plain domain names (letters, digits, dots, dashes)."
  }
}

variable "proxy_connect_ports" {
  description = "With hub_services: destination ports the explicit proxy accepts for HTTPS tunnels (CONNECT). 443 covers the web; add 6514 (syslog TLS) and 12202 (GELF TLS) to let log shippers reach Logs Data Platform through the proxy, 9200 for the OpenSearch API."
  type        = list(number)
  default     = [443]
  validation {
    condition     = contains(var.proxy_connect_ports, 443) && alltrue([for p in var.proxy_connect_ports : p >= 1 && p <= 65535])
    error_message = "proxy_connect_ports must include 443 and contain valid ports."
  }
}

variable "hub_services" {
  description = "Enable the zero-trust hub services on the LAN CARP VIP: unbound DNS, ntpd, explicit squid proxy (os-squid, installed through the firmware API at Day-1) and the matching firewall policy (replaces the 'LAN to any' rule)."
  type        = bool
  default     = false
}
