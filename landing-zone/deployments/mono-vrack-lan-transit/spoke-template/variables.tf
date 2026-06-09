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
  type = string
  validation {
    condition     = contains(["ovh-eu", "ovh-ca", "ovh-us"], var.ovh_endpoint)
    error_message = "Valid values: 'ovh-eu', 'ovh-ca', 'ovh-us'"
  }
}

variable "ovh_application_key" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "ovh_application_secret" {
  type      = string
  sensitive = true
  ephemeral = true
}

variable "ovh_consumer_key" {
  type      = string
  sensitive = true
  ephemeral = true
}

####################################
#           Regions / Common       #
####################################

variable "compute_region" {
  description = "OpenStack region (e.g. GRA11)"
  type        = string
}

####################################
#  Hub references (from outputs    #
#  of landing-zone-one-vrack)      #
####################################

variable "hub_vrack_service_name" {
  description = "Shared vRack service name (from landing-zone-one-vrack output: tofu output hub_vrack_service_name)"
  type        = string
}

variable "hub_floating_ip" {
  description = "Hub OPNsense public floating IP (from landing-zone-one-vrack output)"
  type        = string
}

variable "hub_lan_carp_ip" {
  description = "Hub CARP VIP on the LAN/transit (from landing-zone-one-vrack output: hub_lan_carp_ip)"
  type        = string
}

variable "hub_api_key" {
  description = "Hub OPNsense API key (from landing-zone-one-vrack output)"
  type        = string
  sensitive   = true
}

variable "hub_api_secret" {
  description = "Hub OPNsense API secret (from landing-zone-one-vrack output)"
  type        = string
  sensitive   = true
}

####################################
#        Transit VLAN (= Hub LAN)  #
####################################

variable "hub_lan_vlan_id" {
  description = "Hub LAN VLAN ID (= shared transit VLAN). Must match the hub exactly."
  type        = number
  default     = 200
}

variable "hub_lan_cidr" {
  description = "Hub LAN CIDR (= shared transit subnet). Must match the hub exactly."
  type        = string
  default     = "192.168.10.0/24"
}

variable "transit_router_ip" {
  description = "Fixed spoke router IP on the transit VLAN. Must be outside the hub DHCP pool (.100-.200)."
  type        = string
  default     = "192.168.10.10"
}

####################################
#         Spoke LAN networks       #
####################################

variable "spoke_name" {
  description = "Short spoke identifier — used to name resources (e.g. constellation-dev, signalvault-prod)"
  type        = string
}

variable "networks" {
  description = <<EOT
Map of spoke LAN networks. Each entry creates a vRack network + subnet + router interface.
VLAN IDs must be UNIQUE inside the shared vRack (do not reuse 100, 199, 200).
Convention: 300-399 for the first spoke, 400-499 for the second, etc.
EOT
  type = map(object({
    vlan_id = number
    cidr    = string
  }))
  default = {
    "default" = {
      vlan_id = 300
      cidr    = "10.30.0.0/24"
    }
  }
}
