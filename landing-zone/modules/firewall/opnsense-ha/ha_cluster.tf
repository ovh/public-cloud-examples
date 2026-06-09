########################################################################################
#   Attach Floating IP to OPNsense Primary
########################################################################################

resource "openstack_networking_floatingip_v2" "fw_fip" {
  depends_on = [ovh_cloud_project_gateway.fw_wan_router]

  pool        = "Ext-Net"
  port_id     = openstack_networking_port_v2.fw_wan_carp_vip.id
  description = "Floating IP for OPNsense Primary VM"
}

########################################################################################
#   OPNsense Instance | Active
########################################################################################

resource "openstack_compute_instance_v2" "fw_active" {
  name              = "opnsense-ha-primary"
  image_id          = openstack_images_image_v2.fw_image.id
  flavor_name       = var.os_instance_flavor_name
  key_pair          = openstack_compute_keypair_v2.fw_keypair.name
  availability_zone = var.az_primary

  scheduler_hints {
    group = openstack_compute_servergroup_v2.fw_servergroup.id
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  network {
    port = openstack_networking_port_v2.fw_wan_active_port.id
  }
  network {
    port = openstack_networking_port_v2.fw_lan_active_port.id
  }
  network {
    port = openstack_networking_port_v2.fw_hasync_active_port.id
  }

  config_drive = true

  user_data = base64encode(templatefile("${path.module}/templates/${var.role}/config-active.xml", merge(
    {
      HOSTNAME            = "OPNsense-Primary"
      ADMIN_CLIENT_IP     = var.admin_client_ip
      ADMIN_PASSWORD      = var.admin_password
      ADMIN_SSH_KEY       = openstack_compute_keypair_v2.fw_keypair.public_key
      WAN_PORT_IP         = openstack_networking_port_v2.fw_wan_active_port.fixed_ip[0].ip_address
      WAN_PORT_NETMASK    = split("/", var.private_wan_cidr)[1]
      WAN_GATEWAY_IP      = openstack_networking_subnet_v2.fw_wan_subnet.gateway_ip
      LAN_PORT_IP         = openstack_networking_port_v2.fw_lan_active_port.fixed_ip[0].ip_address
      LAN_PORT_NETMASK    = split("/", var.private_lan_cidr)[1]
      HASYNC_PORT_IP      = openstack_networking_port_v2.fw_hasync_active_port.fixed_ip[0].ip_address
      HASYNC_PORT_NETMASK = split("/", var.private_hasync_cidr)[1]
      HA_PASSWORD         = var.ha_password
      PEER_WAN_IP         = openstack_networking_port_v2.fw_wan_passive_port.fixed_ip[0].ip_address
      PEER_LAN_IP         = openstack_networking_port_v2.fw_lan_passive_port.fixed_ip[0].ip_address
      PEER_HA_IP          = openstack_networking_port_v2.fw_hasync_passive_port.fixed_ip[0].ip_address
      WAN_CARP_IP         = openstack_networking_port_v2.fw_wan_carp_vip.fixed_ip[0].ip_address
      LAN_CARP_IP         = openstack_networking_port_v2.fw_lan_carp_vip.fixed_ip[0].ip_address
      API_KEY             = var.api_key != null ? var.api_key : ""
      API_SECRET_HASH     = var.api_secret_hash != null ? var.api_secret_hash : ""
    },
    var.template_extra_vars
  )))
}

########################################################################################
#   OPNsense Instance | Passive
########################################################################################

resource "openstack_compute_instance_v2" "fw_passive" {
  name              = "opnsense-ha-secondary"
  image_id          = openstack_images_image_v2.fw_image.id
  flavor_name       = var.os_instance_flavor_name
  key_pair          = openstack_compute_keypair_v2.fw_keypair.name
  availability_zone = var.az_secondary

  scheduler_hints {
    group = openstack_compute_servergroup_v2.fw_servergroup.id
  }

  lifecycle {
    ignore_changes = [user_data]
  }

  network {
    port = openstack_networking_port_v2.fw_wan_passive_port.id
  }
  network {
    port = openstack_networking_port_v2.fw_lan_passive_port.id
  }
  network {
    port = openstack_networking_port_v2.fw_hasync_passive_port.id
  }

  config_drive = true

  user_data = base64encode(templatefile("${path.module}/templates/${var.role}/config-passive.xml", merge(
    {
      HOSTNAME            = "OPNsense-Secondary"
      ADMIN_CLIENT_IP     = var.admin_client_ip
      ADMIN_PASSWORD      = var.admin_password
      ADMIN_SSH_KEY       = openstack_compute_keypair_v2.fw_keypair.public_key
      WAN_PORT_IP         = openstack_networking_port_v2.fw_wan_passive_port.fixed_ip[0].ip_address
      WAN_PORT_NETMASK    = split("/", var.private_wan_cidr)[1]
      WAN_GATEWAY_IP      = openstack_networking_subnet_v2.fw_wan_subnet.gateway_ip
      LAN_PORT_IP         = openstack_networking_port_v2.fw_lan_passive_port.fixed_ip[0].ip_address
      LAN_PORT_NETMASK    = split("/", var.private_lan_cidr)[1]
      HASYNC_PORT_IP      = openstack_networking_port_v2.fw_hasync_passive_port.fixed_ip[0].ip_address
      HASYNC_PORT_NETMASK = split("/", var.private_hasync_cidr)[1]
      HA_PASSWORD         = var.ha_password
      PEER_WAN_IP         = openstack_networking_port_v2.fw_wan_active_port.fixed_ip[0].ip_address
      PEER_LAN_IP         = openstack_networking_port_v2.fw_lan_active_port.fixed_ip[0].ip_address
      PEER_HA_IP          = openstack_networking_port_v2.fw_hasync_active_port.fixed_ip[0].ip_address
      WAN_CARP_IP         = openstack_networking_port_v2.fw_wan_carp_vip.fixed_ip[0].ip_address
      LAN_CARP_IP         = openstack_networking_port_v2.fw_lan_carp_vip.fixed_ip[0].ip_address
      API_KEY             = var.api_key != null ? var.api_key : ""
      API_SECRET_HASH     = var.api_secret_hash != null ? var.api_secret_hash : ""
    },
    var.template_extra_vars
  )))
}
