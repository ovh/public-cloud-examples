# Instance

variable "instance" {
  description = "Instance Parameters"
  type = object({
    region       = string
    network_name = string
    keypair_name = string
    name         = string
    flavor       = string
    image        = string
    user         = string
  })
}
