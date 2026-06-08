####################################
#     OpenTofu State Encryption    #
####################################

variable "tofu_state_passphrase" {
  description = "Passphrase used to encrypt the OpenTofu state file (AES-GCM via PBKDF2). Set via TF_VAR_tofu_state_passphrase; the same value is required for every later init/plan/apply."
  type        = string
  sensitive   = true
}

####################################
#           OVH Provider           #
####################################

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
  description = "IP address or CIDR allowed to reach the OPNsense WebGUI (port 8443) and SSH (port 22). Prefer a single fixed IP; a broad range such as /24 is overly permissive."
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
  description = "VLAN ID for the spoke WAN network (must be unique within the vRack)."
  type        = number
  default     = 400
}

variable "spoke_net_lan_vlan_id" {
  description = "VLAN ID for the spoke LAN network (must be unique within the vRack)."
  type        = number
  default     = 401
}

variable "spoke_net_hasync_vlan_id" {
  description = "VLAN ID for the spoke OPNsense HA sync (pfSync/CARP) network."
  type        = number
  default     = 402
}

variable "spoke_private_wan_cidr" {
  description = "CIDR of the spoke WAN subnet (carries the IPsec tunnel to the hub)."
  type        = string
  default     = "10.3.0.0/24"
}

variable "spoke_private_lan_cidr" {
  description = "CIDR of the spoke LAN subnet where workloads are attached."
  type        = string
  default     = "192.168.30.0/24"
}

variable "spoke_private_hasync_cidr" {
  description = "CIDR of the spoke HA-sync subnet (a /30 is enough for the OPNsense pair)."
  type        = string
  default     = "10.0.253.0/30"
}

variable "vti_link_cidr" {
  description = "Point-to-point /30 for the IPsec VTI link between this spoke and the hub (must be unique per spoke)."
  type        = string
  default     = "169.254.0.4/30"
}

