variable "os_tenant_id" {
  description = "OVH Public Cloud project ID (used for API registration)"
  type        = string
}

variable "os_region" {
  description = "OpenStack region"
  type        = string
}

variable "hub_lan_vlan_id" {
  description = "Hub LAN (transit) VLAN ID — must match the hub exactly"
  type        = number
  default     = 200
}

variable "hub_lan_cidr" {
  description = "Hub LAN CIDR (same shared subnet)"
  type        = string
  default     = "192.168.10.0/24"
}

variable "hub_lan_carp_ip" {
  description = "Hub CARP VIP on the LAN (= default gateway of the spoke router)"
  type        = string
}

variable "transit_router_ip" {
  description = "Fixed IP assigned to the spoke router port on the transit VLAN (must be outside the hub DHCP pool, which starts at .100)"
  type        = string
  default     = "192.168.10.10"
}

variable "spoke_name" {
  description = "Short spoke identifier — used to name OpenStack resources (e.g. constellation-dev)"
  type        = string
}

variable "networks" {
  description = "Map of spoke LAN networks. Example: { \"app\" = { vlan_id = 300, cidr = \"10.30.0.0/24\" } }"
  type = map(object({
    vlan_id = number
    cidr    = string
  }))
}
