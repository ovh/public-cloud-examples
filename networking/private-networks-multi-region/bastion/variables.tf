# Openstack project Id

variable "serviceName" {
  type = string
}

# Bastion parameters

variable "bastion" {
  type = object({
    frontNwName   = string
    bRegion       = string
    bSubnetCIDR   = string
    bRtrIp        = string
    bastionName   = string
    bastionFlavor = string
    bastionImage  = string
    bastionUser   = string
    bastionIP     = string
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

