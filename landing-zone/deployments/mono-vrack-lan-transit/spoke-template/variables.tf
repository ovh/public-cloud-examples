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
  type    = string
  default = "ovh-eu"
  validation {
    condition     = contains(["ovh-eu", "ovh-ca", "ovh-us"], var.ovh_endpoint)
    error_message = "Valid values: 'ovh-eu', 'ovh-ca', 'ovh-us'"
  }
}
variable "ovh_application_key" {
  type      = string
  sensitive = true
  ephemeral = true
  default   = null
}
variable "ovh_application_secret" {
  type      = string
  sensitive = true
  ephemeral = true
  default   = null
}
variable "ovh_consumer_key" {
  type      = string
  sensitive = true
  ephemeral = true
  default   = null
}

####################################
#  The spoke: a name and a slot    #
####################################
variable "spoke_name" {
  description = "Short spoke identifier — names the project and every resource (e.g. finance-qa)"
  type        = string
}
variable "slot" {
  description = "Slot number (1..slot_count of the hub), unique per spoke, never 2 or 3 (default MKS pod/service ranges). Fixes the supernet 10.<slot>.0.0/16, the VLANs and the transit IP."
  type        = number
}
variable "networks" {
  description = "Spoke LANs: name => index 0..9 (LAN = 10.<slot>.<index>.0/24)"
  type        = map(number)
  default     = { app = 0 }
}
variable "extra_egress" {
  description = "Optional public whitelist added to the base security group (empty = proxy only)"
  type = list(object({
    cidr     = string
    port     = number
    protocol = string
  }))
  default = []
}

####################################
#  Hub facts (tofu output spoke_inputs on the landing zone)
####################################
variable "compute_region" {
  type    = string
  default = "EU-WEST-PAR"
}
variable "hub_vrack_service_name" {
  description = "vRack of the hub — the spoke project joins it at order time"
  type        = string
}
variable "hub_lan_vlan_id" {
  type    = number
  default = 200
}
variable "hub_lan_cidr" {
  type    = string
  default = "192.168.10.0/24"
}
variable "hub_lan_carp_ip" {
  type = string
}
