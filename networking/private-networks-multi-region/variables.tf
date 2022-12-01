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
  })
}

// Network by regions parameters

variable "z" {
  type = list(object({
    region            = string
    frontSubnetCIDR   = string
    backSubnetCIDR    = string
    backRouterFrontIP = string
    backRouterBackIP  = string
  }))
}

