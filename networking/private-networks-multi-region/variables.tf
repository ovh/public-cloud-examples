# Openstack project Id

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
    multiSubnetName = string
    multiSubnetCIDR = string
  })
}

# Network by regions parameters

variable "multi" {
  type = list(object({
    region           = string
    monoSubnetCIDR   = string
    routerMonoNwIP   = string
    routerMultiNwIP  = string
    multiSubnetStart = string
    multiSubnetEnd   = string
    monoSubnetStart  = string
    monoSubnetEnd    = string
  }))
}

# Network Routes

variable "routes" {
  type = list(object({
    region        = string
    nextHopRoute1 = string
    nextHopRoute2 = string
    destRoute1    = string
    destRoute2    = string
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
    networkName     = string
    region          = string
    name            = string
    flavor          = string
    image           = string
    user            = string
  })
}

# Target parameters

variable "target" {
  type = object({
    networkName = string
    region      = string
    name        = string
    flavor      = string
    image       = string
    user        = string
  })
}
