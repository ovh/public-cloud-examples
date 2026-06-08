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
  validation {
    condition     = contains(["ovh-eu", "ovh-ca", "ovh-us"], var.ovh_endpoint)
    error_message = "Valid values for 'ovh_endpoint' are 'ovh-eu', 'ovh-ca', 'ovh-us'"
  }
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

####################################
#         Regions / Common         #
####################################

variable "compute_region" {
  description = "Default region for Compute OVH services (e.g. BHS5, GRA9, SBG7, etc.)"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to an SSH public key file for OPNsense instances (e.g. ~/.ssh/id_rsa.pub). If null, auto-generated."
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

####################################
#              Hub                 #
####################################

variable "hub_flavor" {
  description = "OPNsense hub instance flavor name"
  type        = string
  default     = "b3-16"
}

variable "hub_net_wan_vlan_id" {
  description = "Hub WAN VLAN ID"
  type        = number
  default     = 100
}

variable "hub_private_wan_cidr" {
  description = "Hub private WAN CIDR"
  type        = string
  default     = "10.1.0.0/24"
}

variable "hub_net_lan_vlan_id" {
  description = "Hub LAN VLAN ID"
  type        = number
  default     = 200
}

variable "hub_private_lan_cidr" {
  description = "Hub private LAN CIDR"
  type        = string
  default     = "192.168.10.0/24"
}

variable "hub_net_hasync_vlan_id" {
  description = "Hub HASYNC VLAN ID"
  type        = number
  default     = 199
}

variable "hub_private_hasync_cidr" {
  description = "Hub private HASYNC CIDR"
  type        = string
  default     = "10.0.254.0/30"
}
