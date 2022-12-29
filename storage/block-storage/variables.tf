# Openstack project Id

variable "serviceName" {
  description = "Service Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Block Storage Volume

variable "bsName" {
  description = "Block Storage Name"
  type        = string
}

variable "bsSize" {
  description = "Block Storage Size"
  type        = number
}
