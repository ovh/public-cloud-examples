# Openstack project Id

variable "serviceName" {
  description = "Service Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "pvNetworkName" {
  description = "Private Network Name"
  type        = string
}

variable "pvNetworkId" {
  description = "Private Network Id"
  type        = string
}

# Network - Subnet

variable "subnetName" {
  description = "Subnet Name"
  type        = string
}

variable "subnetCIDR" {
  description = "Subnet CIDR"
  type        = string
}

variable "subnetDHCPStart" {
  description = "Subnet DHCP Range start"
  type        = string
}

variable "subnetDHCPEnd" {
  description = "Subnet DHCP Range end"
  type        = string
}

# Network - Router

variable "rtrName" {
  description = "Router Name"
  type        = string
}

variable "rtrIp" {
  description = "Router Ip"
  type        = string
}
