# Openstack project Id

variable "serviceName" {
  type = string
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

# SSH keypair

variable "keypair" {
  type = object({
    keypairName               = string
    keypairMainRegion         = string
    keypairToReproduceRegions = list(string)
  })
}

