########################################################################################
# OpenTofu state encryption
########################################################################################

variable "tofu_state_passphrase" {
  description = "Passphrase used to encrypt the OpenTofu state file (AES-GCM via PBKDF2)"
  type        = string
  sensitive   = true
}

########################################################################################
# OVH API credentials
# Generate at: https://api.ovh.com/createToken/
# Required rights: GET/POST/PUT/DELETE on /cloud/project/{projectId}/*
########################################################################################

variable "ovh_endpoint" {
  description = "OVH API endpoint (ovh-eu | ovh-ca | ovh-us)"
  type        = string
  default     = "ovh-eu"
}

variable "ovh_application_key" {
  description = "OVH API application key"
  type        = string
  sensitive   = true
}

variable "ovh_application_secret" {
  description = "OVH API application secret"
  type        = string
  sensitive   = true
}

variable "ovh_consumer_key" {
  description = "OVH API consumer key"
  type        = string
  sensitive   = true
}

########################################################################################
# Existing OVHcloud project
# Prerequisites:
#   - The project must already exist
#   - A vRack must already be attached to the project
########################################################################################

variable "project_id" {
  description = "OVHcloud Public Cloud project ID (existing project with a vRack attached)"
  type        = string
}

variable "region" {
  description = "OVHcloud compute region (e.g. EU-WEST-PAR, EU-SOUTH-MIL, GRA11, SBG7, BHS5). For 3-AZ regions, HA placement across availability zones is automatic."
  type        = string
}

########################################################################################
# OPNsense instance
########################################################################################

variable "flavor" {
  description = "Instance flavor for OPNsense nodes"
  type        = string
  default     = "b3-16"
}

variable "ssh_public_key_path" {
  description = "Path to an SSH public key file. If null, a keypair is auto-generated and the private key is available via `tofu output -json`."
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
  description = "CIDR for the WAN network (OVHcloud managed gateway is provisioned on this subnet)"
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
  description = "IP address or CIDR allowed to reach the OPNsense WebGUI (port 8443) and SSH (port 22). Prefer a single fixed IP; a broad range such as /24 is overly permissive."
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
