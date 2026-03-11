variable demo_name {
  type        = string
  default     = "classic-multiattach"
}

variable region_name {
  type        = string
  default     = "EU-WEST-PAR"
}

variable availability_zones_name {
  type    = list(string)
  default = ["eu-west-par-a", "eu-west-par-b", "eu-west-par-c"]
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

variable volume_size {
  type    = string
  default = "1"
}