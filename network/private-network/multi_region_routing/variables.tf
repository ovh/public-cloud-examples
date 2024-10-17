########################################################################################
#     Variables
########################################################################################

variable "ovh_public_cloud_project_id" {
  type = string
}

variable "region1" {
  type    = string
  default = "GRA11"
}
variable "region1_vlanid" {
  type    = number
  default = "1000"
}

variable "region2" {
  type    = string
  default = "SBG7"
}

variable "region2_vlanid" {
  type    = number
  default = "2000"
}

variable "resource_prefix" {
  type    = string
  default = "tf_at_ovhcloud_multiregion_peering"
}
variable "image_name" {
  type    = string
  default = "Ubuntu 22.04"
}
variable "instance_flavor" {
  type    = string
  default = "b3-8"
}
variable "external_network" {
  type    = string
  default = "Ext-Net"
}

variable "public_key_path" {
  type    = string
  default = "~/.ssh/id_ed25519.pub"
}

variable "default_dns_resolver" {
  type    = string
  default = "213.186.33.99"
}

