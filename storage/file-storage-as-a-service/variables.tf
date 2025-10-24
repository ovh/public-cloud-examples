variable demo_name {
  type        = string
  default     = "manila"
}

variable region_name {
  type        = string
  default     = "SBG5"
}

variable private_network_vlan_id {
  type        = string
  default     = "11"
}

variable gateway_size {
  type        = string
  default     = "s"
}

variable instance_image_name {
  type        = string
  default     = "Ubuntu 24.04"
}

variable instance_flavor_name {
  type        = string
  default     = "b3-8"
}

variable ssh_public_key {
  type    = string
}

variable share_size {
  type    = string
  default = "10"
}