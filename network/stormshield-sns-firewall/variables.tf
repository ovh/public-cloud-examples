variable ovh_os_instance_name {
  type    = string
  default = "stormshield"
}

variable ovh_os_instance_password {
  type    = string
}

variable ssh_public_key {
  type    = string
}

variable admin_client_ip {
  type     = string
}

variable ovh_os_instance_wan_ip {
  type    = list(string)
}

variable ovh_os_instance_wan_mask {
  type    = string
}

variable ovh_os_instance_wan_gw {
  type    = string
}

variable ovh_os_instance_region {
  type    = string
  default = "SBG7"
}

variable ovh_os_instance_image_name {
  type    = string
  default = "utm-SNS-EVA-4.8.11"
}

variable ovh_os_instance_flavor_name {
  type    = string
  default = "b3-16"
}

variable ovh_os_private_network_vlan_id {
  type = number
  default = 200
}

variable ovh_os_private_network_ha_vlan_id {
  type = number
  default = 199
}

variable stormshield_serial_number {
  type = list(string)
}