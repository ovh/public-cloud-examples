variable "ovh_endpoint" {
  description = "OVH Endpoint"
  type        = string
}

variable "ovh_application_key" {
  description = "OVH Application Key"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "ovh_application_secret" {
  description = "OVH Application Secret"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "ovh_consumer_key" {
  description = "OVH Consumer Key"
  type        = string
  sensitive   = true
  ephemeral   = true
}

variable "compute_region" {
  description = "OpenStack region"
  type        = string
}

variable "ssh_public_key_path" {
  description = "SSH public key path (optional)"
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
  description = "Firewall HA password"
  type        = string
  sensitive   = true
}

variable "ipsec_pre_shared_key" {
  description = "IPsec PSK"
  type        = string
  sensitive   = true
}

variable "hub_floating_ip" {
  description = "Existing hub floating IP"
  type        = string
}

variable "hub_private_wan_cidr" {
  description = "Existing hub private WAN CIDR (peer ID)"
  type        = string
}

variable "hub_wan_carp_ip" {
  description = "Existing hub WAN CARP VIP IP (used as local_addrs for IPsec on hub)"
  type        = string
}

variable "hub_api_key" {
  description = "OPNsense API key (from landing-zone outputs: tofu output hub_api_key)"
  type        = string
  sensitive   = true
}

variable "hub_api_secret" {
  description = "OPNsense API secret (from landing-zone outputs: tofu output -raw hub_api_secret)"
  type        = string
  sensitive   = true
}

variable "ipsec_reqid" {
  description = "IPsec reqid used for the VTI (must be unique per spoke)"
  type        = number
  default     = 100
}

variable "spoke_project_description" {
  description = "Spoke project description"
  type        = string
  default     = "Spoke"
}

variable "spoke_vrack_name" {
  description = "Spoke vRack name"
  type        = string
  default     = "spoke-vrack"
}

variable "spoke_vrack_description" {
  description = "Spoke vRack description"
  type        = string
  default     = "Spoke vRack"
}

variable "spoke_flavor" {
  description = "OPNsense spoke flavor"
  type        = string
  default     = "b3-8"
}

variable "spoke_net_wan_vlan_id" {
  type    = number
  default = 400
}

variable "spoke_net_lan_vlan_id" {
  type    = number
  default = 401
}

variable "spoke_net_hasync_vlan_id" {
  type    = number
  default = 402
}

variable "spoke_private_wan_cidr" {
  type    = string
  default = "10.3.0.0/24"
}

variable "spoke_private_lan_cidr" {
  type    = string
  default = "192.168.30.0/24"
}

variable "spoke_private_hasync_cidr" {
  type    = string
  default = "10.0.253.0/30"
}

variable "vti_link_cidr" {
  type    = string
  default = "169.254.0.4/30"
}

