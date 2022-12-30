# Openstack project Id

variable "service_name" {
  description = "Service Name"
  type        = string
}

# Network common parameters

variable "common" {
  description = "Network common Values"
  type = object({
    regions           = list(string)
    mono_nw_name      = string
    mono_subnet_name  = string
    router_name       = string
    multi_nw_name     = string
    multi_nw_vlan_id  = number
    multi_subnet_name = string
    multi_subnet_cidr = string
  })
}

# Network by regions parameters

variable "multi" {
  description = "Network by regions Values"
  type = list(object({
    region             = string
    mono_subnet_cidr   = string
    router_mono_nw_ip  = string
    router_multi_nw_ip = string
    multi_subnet_start = string
    multi_subnet_end   = string
    mono_subnet_start  = string
    mono_subnet_end    = string
  }))
}

# Network Routes

variable "routes" {
  description = "Routes"
  type = list(object({
    region          = string
    next_hop_route1 = string
    next_hop_route2 = string
    dest_route1     = string
    dest_route2     = string
  }))
}

# SSH keypair

variable "keypair" {
  description = "Keypair"
  type = object({
    name                 = string
    main_region          = string
    to_reproduce_regions = list(string)
  })
}

# Bastion parameters

variable "bastion" {
  description = "Bastion Instance"
  type = object({
    network_name = string
    region       = string
    name         = string
    flavor       = string
    image        = string
    user         = string
  })
}

# Target parameters

variable "target" {
  description = "Target Instance"
  type = object({
    network_name = string
    region       = string
    name         = string
    flavor       = string
    image        = string
    user         = string
  })
}
