# Openstack project Id

variable "service_name" {
  description = "Service Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Block Storage Volume

variable "bs_name" {
  description = "Block Storage Name"
  type        = string
}

variable "bs_size" {
  description = "Block Storage Size"
  type        = number
}
