# Openstack project Id

variable "serviceName" {
  type = string
}

# Bastion parameters

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

# SSH keypair

variable "keypair" {
  type = object({
    keypairName               = string
    keypairMainRegion         = string
    keypairToReproduceRegions = list(string)
  })
}
