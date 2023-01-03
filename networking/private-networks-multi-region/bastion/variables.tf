# Bastion parameters

variable "bastion" {
  description = "Bastion Instance"
  type = object({
    network_name = string
    region       = string
    name         = string
    flavor       = string
    image        = string
    user         = string
  })
}

# SSH keypair

variable "keypair" {
  description = "Keypair"
  type = object({
    name                 = string
    main_region          = string
    to_reproduce_regions = list(string)
  })
}
