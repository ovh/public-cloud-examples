# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "network" {
  description = "Private Network Parameters"
  type = object({
    name = string
  })
}

# Network - Subnet

variable "subnet" {
  description = "Subnet parameters"
  type = object({
    name       = string
    cidr       = string
    dhcp_start = string
    dhcp_end   = string
  })
}

# Network - Router

variable "router" {
  description = "Router Parameters"
  type = object({
    name = string
  })
}
