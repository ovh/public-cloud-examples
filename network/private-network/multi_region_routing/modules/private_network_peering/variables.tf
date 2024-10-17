
variable "peering_vlan_id" {
  type        = string
  description = "the vlan id that is used to create private network and used as peering. It must be different from any other vlan ID used by other private network"
  default     = "42"
}

variable "resource_prefix" {
  type        = string
  default     = "peering_vlan"
  description = "the prefix used for resource name"
}

variable "peering_cidr_block" {
    type = string
    default = "10.42.0.0/28"
}
variable "networks_to_peer" {
  type        = map(
    object({
        subnet_id = string
        router_id = string
        gateway_ip = string
        allocation_pool = object ({
            start = string
            end = string
        })
        route_cidr = string
        route_next_hop = string
  }))
}


