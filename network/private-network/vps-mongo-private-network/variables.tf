# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "network" {
  description = "Private Network Parameters"
  type = object({
    name = string
  })
}

# Network - Subnet

variable "subnet" {
  description = "Subnet parameters"
  type = object({
    name       = string
    cidr       = string
    dhcp_start = string
    dhcp_end   = string
  })
}

# Network - Router

variable "router" {
  description = "Router Parameters"
  type = object({
    name = string
  })
}

# Database Engine

variable "db_engine" {
  description = "Db Engine parameters"
  type = object({
    region          = string
    pv_network_name = string
    subnet_name     = string
    description     = string
    engine          = string
    version         = string
    plan            = string
    flavor          = string
    user_name       = string
    user_role       = list(string)
    allowed_ip      = list(string)
  })
}

# SSH keypair

variable "keypair" {
  description = "Keypair"
  type = object({
    name                 = string
    main_region          = string
    to_reproduce_regions = list(string)
    keys_path            = string
  })
}

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

# Floating IP

variable "floatip" {
  description = "Floating IP"
  type = object({
    region       = string
    component_id = string
  })
  default = {
    region       = ""
    component_id = ""
  }
}
