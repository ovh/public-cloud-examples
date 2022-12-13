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
    backSubnetStart    = string
    backSubnetEnd      = string
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

# Target parameters

variable "target" {
  type = object({
    frontNwName    = string
    bRegion        = string
    bSubnetCIDR    = string
    bRtrIp         = string
    bGateway       = string
    targetName     = string
    targetFlavor   = string
    targetImage    = string
    targetUser     = string
    targetIP       = string
    backSubnetCIDR = string
  })
}
