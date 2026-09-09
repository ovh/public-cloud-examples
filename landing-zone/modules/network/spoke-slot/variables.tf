########################################################################################
#   Spoke slot: everything derives from one number. Slot k gets
#     supernet   = cidrsubnet(slot_supernet_base, 8, k)         10.k.0.0/16
#     LAN n      = cidrsubnet(supernet, 8, n)                    10.k.n.0/24   (n = 0..9)
#     VLAN n     = slot_vlan_base + 10*k + n                      1010+n for slot 1
#     transit IP = cidrhost(hub_lan_cidr, slot_transit_offset+k)  192.168.10.11 for slot 1
#   The hub pre-provisions the matching gateway + route, so no Day-2 call to the hub is needed.
########################################################################################

variable "spoke_name" {
  description = "Short spoke identifier used to name resources (e.g. finance-qa)"
  type        = string
}

variable "slot" {
  description = "Slot number of this spoke (1..slot_count of the hub). Must be unique across spokes."
  type        = number
  validation {
    condition     = var.slot >= 1 && var.slot <= 200
    error_message = "slot must be between 1 and 200."
  }
}

variable "slot_supernet_base" {
  description = "Same value as the hub (default 10.0.0.0/8)"
  type        = string
  default     = "10.0.0.0/8"
}

variable "slot_transit_offset" {
  description = "Same value as the hub (default 10)"
  type        = number
  default     = 10
}

variable "slot_vlan_base" {
  description = "VLAN IDs of spoke LANs are slot_vlan_base + 10*slot + index (must not collide with the hub VLANs)"
  type        = number
  default     = 1000
}

variable "hub_lan_vlan_id" {
  description = "Hub LAN VLAN ID (= transit VLAN shared through the vRack)"
  type        = number
}

variable "hub_lan_cidr" {
  description = "Hub LAN CIDR (= transit subnet); the spoke router takes a fixed IP in it"
  type        = string
}

variable "hub_lan_carp_ip" {
  description = "Hub LAN CARP VIP: default gateway of the spoke router and address of the hub services (DNS, NTP, proxy)"
  type        = string
}

variable "proxy_port" {
  description = "Explicit proxy port on the hub VIP"
  type        = number
  default     = 3128
}

variable "networks" {
  description = "Spoke LAN networks: name => index (0..9). Each becomes cidrsubnet(supernet, 8, index) with VLAN slot_vlan_base + 10*slot + index."
  type        = map(number)
  default     = { app = 0 }
  validation {
    condition     = alltrue([for i in values(var.networks) : i >= 0 && i <= 9])
    error_message = "network indexes must be between 0 and 9."
  }
}

variable "extra_egress" {
  description = "Optional whitelist: extra egress rules for the base security group, e.g. [{ cidr = \"198.27.92.0/24\", port = 443, protocol = \"tcp\" }]. Use sparingly — every public destination here is reachable directly, proxy or not."
  type = list(object({
    cidr     = string
    port     = number
    protocol = string
  }))
  default = []
}

variable "allow_kube_default_cidr_overlap" {
  description = "Slots 2 and 3 map to 10.2.0.0/16 and 10.3.0.0/16, which are the default pod (Free plan) and service CIDRs of OVHcloud Managed Kubernetes; a spoke on those slots collides with any cluster left on defaults (the `kubernetes` ClusterIP 10.3.0.1 is the gateway of slot 3). They are refused unless this flag is set — do it only for a spoke that will never host or talk to a cluster with default CIDRs."
  type        = bool
  default     = false
}

variable "strip_default_secgroup" {
  description = "Remove the implicit allow-all rules of the project's 'default' security group (instances booted without an explicit SG then have no connectivity). Requires the openstack CLI and OS_* credentials in the environment of the machine running tofu."
  type        = bool
  default     = true
}

variable "openstack_cli_auth" {
  description = "Environment for the openstack CLI used by strip_default_secgroup (OS_AUTH_URL, OS_USERNAME, OS_PASSWORD, OS_PROJECT_ID, OS_REGION_NAME…). Mandatory when strip_default_secgroup is true: without it the CLI would inherit whatever credentials the operator's shell or clouds.yaml provides — and touch the wrong project."
  type        = map(string)
  default     = {}
  sensitive   = true
}
