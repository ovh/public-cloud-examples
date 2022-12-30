# Openstack project Id

variable "service_name" {
  description = "Service Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "pv_network_name" {
  description = "Private Network Name"
  type        = string
}

# Network - Subnet

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
}

variable "subnet_dhcp_start" {
  description = "Subnet DHCP Range start"
  type        = string
}

variable "subnet_dhcp_end" {
  description = "Subnet DHCP Range end"
  type        = string
}

# Network - Router

variable "rtr_name" {
  description = "Router Name"
  type        = string
}
