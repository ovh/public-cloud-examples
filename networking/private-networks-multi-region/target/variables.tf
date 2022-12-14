# Target parameters

variable "target" {
  type = object({
    networkName     = string
    region          = string
    name            = string
    flavor          = string
    image           = string
    user            = string
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
