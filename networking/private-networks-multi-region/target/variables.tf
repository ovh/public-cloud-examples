# Openstack project Id

variable "serviceName" {
  type = string
}

# Target parameters

variable "target" {
  type = object({
    networkName     = string
    region          = string
    subnetCIDR      = string
    rtrIp           = string
    name            = string
    flavor          = string
    image           = string
    user            = string
    fixedIP         = string
    subnetMultiCIDR = string
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

