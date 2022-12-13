// Openstack project Id

variable "serviceName" {
  type = string
}

// Network common parameters

variable "common" {
  type = object({
    regions         = list(string)
    monoNwName      = string
    monoSubnetName  = string
    routerName      = string
    multiNwName     = string
    multiNwVlanId   = number
    backSubnetName  = string
    backRouterName  = string
    multiSubnetCIDR = string
  })
}

# Network by regions parameters

variable "multi" {
  type = list(object({
    region             = string
    monoSubnetCIDR     = string
    routerMonoNwIP  = string
    routerMultiNwIP    = string
    multiSubnetStart   = string
    multiSubnetEnd     = string
  }))
}
