// Openstack project Id

variable "serviceName" {
  type = string
}

// Region

variable "region" {
  type = string
}

// Network - Private Network

variable "pvNetworkName" {
  type = string
}

variable "pvNetworkId" {
  type = string
}

// Network - Subnet

variable "subnetName" {
  type = string
}

variable "subnetCIDR" {
  type = string
}

variable "subnetDHCPStart" {
  type = string
}

variable "subnetDHCPEnd" {
  type = string
}

// Network - Router

variable "rtrName" {
  type = string
}

variable "rtrIp" {
  type = string
}
