// Openstack project Id

variable "serviceName" {
  type = string
}

// Network common parameters

variable "common" {
  type = object({
    regions         = list(string)
    frontNwName     = string
    frontSubnetName = string
    frontRouterName = string
    backNwName      = string
    backNwVlanId    = number
    backSubnetName  = string
    backRouterName  = string
    portName        = string
    backSubnetCIDR  = string
  })
}

# Network by regions parameters

variable "multi" {
  type = list(object({
    region             = string
    frontSubnetCIDR    = string
    frontRouterFrontIP = string
    backRouterFrontIP  = string
    backRouterBackIP   = string
  }))
}
