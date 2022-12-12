# Openstack project Id

variable "serviceName" {
  type = string
}

# Network common parameters

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

# SSH keypair

variable "keypair" {
  type = object({
    keypairName               = string
    keypairMainRegion         = string
    keypairToReproduceRegions = list(string)
  })
}

# Bastion parameters

variable "bastion" {
  type = object({
    frontNwName    = string
    bRegion        = string
    bSubnetCIDR    = string
    bRtrIp         = string
    bGateway       = string
    bastionName    = string
    bastionFlavor  = string
    bastionImage   = string
    bastionUser    = string
    bastionIP      = string
    backSubnetCIDR = string
  })
}

# Back parameters

variable "back" {
  type = object({
    backNwName  = string
    bRegion     = string
    bSubnetCIDR = string
    bRtrIp      = string
    backName    = string
    backFlavor  = string
    backImage   = string
    backUser    = string
    backIP      = string
  })
}
