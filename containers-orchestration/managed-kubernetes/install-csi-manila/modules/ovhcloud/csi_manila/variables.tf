variable "service_name" {
  description = "Public Cloud project ID"
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]{32}$", var.service_name))
    error_message = "The service name is not a project ID"
  }
}

variable "region" {
  description = "Region"
  type        = string

  validation {
    condition     = can(regex("^((BHS|DE|GRA|MUM|SBG|SPG|SYD|UK|WAW)[0-9]{1,2}|RBX-[A-Z]|EU-WEST-PAR|EU-SOUTH-MIL|CA-EAST-TOR)$", var.region))
    error_message = "The region is not valid"
  }
}

variable "share_network_name" {
  description = "Share network name"
  type        = string
}

variable "network_id" {
  description = "Network ID"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
}