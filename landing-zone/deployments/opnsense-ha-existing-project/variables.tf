########################################################################################
# OpenTofu state encryption
########################################################################################

variable "tofu_state_passphrase" {
  description = "Passphrase used to encrypt the OpenTofu state file (AES-GCM via PBKDF2)"
  type        = string
  sensitive   = true
}

########################################################################################
# Existing OVHcloud project
# Prerequisites:
#   - The project must already exist and have a vRack attached
#   - OpenStack credentials (openrc.sh) of a user with the administrator role — the
#     project ID comes from OS_PROJECT_ID, no OVH API token is required
########################################################################################

variable "region" {
  description = "OVHcloud compute region (e.g. GRA9, GRA11, SBG7, BHS5, EU-WEST-PAR, EU-SOUTH-MIL). For 3-AZ regions, HA placement across availability zones is automatic."
  type        = string
}

########################################################################################
# OPNsense instance
########################################################################################

variable "opnsense_version" {
  description = "OPNsense release of the cloud-ready image. The configuration templates target the 26.7 model (MVC firewall rules, source NAT, HA sync)."
  type        = string
  default     = "26.7"
}

variable "flavor" {
  description = "Instance flavor for OPNsense nodes"
  type        = string
  default     = "b3-16"
}

variable "ssh_public_key_path" {
  description = "Path to an SSH public key file. If null, a keypair is auto-generated and the private key is available via `tofu output -raw ssh_private_key`."
  type        = string
  default     = null
}

########################################################################################
# Network — VLAN IDs and CIDRs
# All networks are vRack-backed. VLANs must not conflict with other resources in the vRack.
########################################################################################

variable "vlan_wan" {
  description = "VLAN ID for the WAN (uplink) network"
  type        = number
  default     = 100
}

variable "cidr_wan" {
  description = "CIDR for the WAN network (the Neutron router / OVHcloud gateway takes the first address)"
  type        = string
  default     = "10.1.0.0/24"
}

variable "vlan_lan" {
  description = "VLAN ID for the LAN (downstream) network"
  type        = number
  default     = 200
}

variable "cidr_lan" {
  description = "CIDR for the LAN network (workloads use the CARP VIP as their default gateway)"
  type        = string
  default     = "192.168.10.0/24"
}

variable "vlan_hasync" {
  description = "VLAN ID for the dedicated HA sync network (pfsync + xmlrpc)"
  type        = number
  default     = 199
}

variable "cidr_hasync" {
  description = "CIDR for the HA sync network (/30 is sufficient — only 2 IPs needed)"
  type        = string
  default     = "10.0.254.0/30"
}

########################################################################################
# Firewall access
########################################################################################

variable "admin_client_ip" {
  description = "IP address or CIDR allowed to reach the OPNsense WebGUI (port 8443) and SSH (port 22). Stored in the AdminClients alias, editable afterwards in the GUI. Prefer a single fixed IP; a broad range such as /24 is overly permissive."
  type        = string
}

variable "admin_password" {
  description = "Password for OPNsense root and admin accounts"
  type        = string
  sensitive   = true
}

variable "ha_password" {
  description = "Shared password used for CARP advertisements and HA config synchronization (xmlrpc)"
  type        = string
  sensitive   = true
}
