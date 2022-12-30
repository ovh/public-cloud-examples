# Openstack project Id

variable "service_name" {
  description = "Service Name"
  type        = string
}

# Network common parameters

variable "common" {
  description = "Common Network Values"
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
