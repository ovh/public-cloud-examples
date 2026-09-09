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
# Leave the three keys null to use a service account (OVH_CLIENT_ID / OVH_CLIENT_SECRET)
####################################
variable "ovh_endpoint" {
  description = "OVH Endpoint"
  type        = string
  default     = "ovh-eu"
  validation {
    condition     = contains(["ovh-eu", "ovh-ca", "ovh-us"], var.ovh_endpoint)
    error_message = "Valid values for 'ovh_endpoint' are 'ovh-eu', 'ovh-ca', 'ovh-us'"
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
#         Regions / Common         #
####################################
variable "compute_region" {
  description = "Compute region (e.g. GRA9, GRA11, SBG7, BHS5, EU-WEST-PAR)"
  type        = string
  default     = "EU-WEST-PAR"
}
variable "ssh_public_key_path" {
  description = "SSH public key for the OPNsense admin user. If null, a keypair is generated and the private key is written next to the state (.ssh/hub_key) — it is needed to finish Day-1 on the secondary node."
  type        = string
  default     = null
}
variable "admin_client_ip" {
  description = "IP address or CIDR allowed to reach the OPNsense WebGUI (port 8443) and SSH (port 22) — seeds the AdminClients alias. Prefer a single fixed IP; a broad range such as /24 is overly permissive."
  type        = string
}
variable "admin_password" {
  type      = string
  sensitive = true
}
variable "ha_password" {
  type      = string
  sensitive = true
}

####################################
#              Hub                 #
####################################
variable "hub_flavor" {
  description = "OPNsense hub instance flavor"
  type        = string
  default     = "b3-16"
}
variable "opnsense_version" {
  description = "OPNsense cloud-ready image release"
  type        = string
  default     = "26.7"
}
variable "slot_count" {
  description = "Number of spoke slots pre-provisioned on the hub (gateway + route objects in OPNsense, no OVH resource). Each spoke picks one slot number; extend later with a new apply."
  type        = number
  default     = 20
}
variable "hub_services" {
  description = "Zero-trust hub services on the LAN VIP (unbound DNS, ntpd, explicit squid proxy) and the matching policy. Set false for a plain routing hub with 'LAN to any'."
  type        = bool
  default     = true
}

variable "proxy_allowed_domains" {
  description = "Internet destinations the hub proxy lets workloads reach (domain suffixes, e.g. [\"ubuntu.com\", \"docker.io\", \"pypi.org\"]). Empty = any destination; every request is logged either way. Requires hub_services."
  type        = list(string)
  default     = []
}

variable "proxy_connect_ports" {
  description = "Destination ports the hub proxy tunnels (CONNECT). Keep 443; add 6514 and 12202 when workloads ship logs to Logs Data Platform through the proxy."
  type        = list(number)
  default     = [443]
}

variable "hub_remote_syslog" {
  description = "Send the hub's own logs (firewall pass/block, DHCP, DNS, proxy) to a remote syslog receiver over TLS — e.g. a Logs Data Platform dedicated input: { host = \"<input>.logs.ovh.com\", port = 6514 }. Applied by the post-boot step on both nodes; null = local logs only."
  type = object({
    host = string
    port = optional(number, 6514)
  })
  default = null
}

# Hub networks — keep them outside 10.0.0.0/8, which is carved into one /16 per spoke slot.
variable "hub_net_wan_vlan_id" {
  type    = number
  default = 100
}
variable "hub_private_wan_cidr" {
  type    = string
  default = "172.16.0.0/24"
}
variable "hub_net_lan_vlan_id" {
  description = "Hub LAN VLAN = the transit VLAN every spoke joins"
  type        = number
  default     = 200
}
variable "hub_private_lan_cidr" {
  description = "Hub LAN CIDR = transit subnet. Slot k's router takes .(10+k); the hub DHCP pool is .100-.200"
  type        = string
  default     = "192.168.10.0/24"
}
variable "hub_net_hasync_vlan_id" {
  type    = number
  default = 199
}
variable "hub_private_hasync_cidr" {
  type    = string
  default = "172.16.254.0/30"
}
