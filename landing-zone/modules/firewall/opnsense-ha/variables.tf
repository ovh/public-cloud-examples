variable "os_tenant_id" {
  description = "OVH Public Cloud project ID (used for registering SSH key)"
  type        = string
}

variable "os_region" {
  description = "OpenStack region (e.g. GRA11, SBG7, BHS5)"
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
  description = "Path to an SSH public key file. If null, a keypair is auto-generated."
  type        = string
  default     = null
}

variable "admin_client_ip" {
  description = "Firewall admin client IP"
  type        = string
}

variable "admin_password" {
  description = "Firewall admin password"
  type        = string
  sensitive   = true
}

variable "ha_password" {
  description = "OPNsense system HA config password"
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
  description = "OPNsense configuration role. Selects the XML template set to inject. One of: hub-simple, hub-ipsec, spoke-ipsec."
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
