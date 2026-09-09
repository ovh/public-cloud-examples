########################################################################################
#   Template variables shared by both nodes (slots, services)
########################################################################################

locals {
  slots = [
    for k in range(1, var.slot_count + 1) : {
      k          = k
      supernet   = cidrsubnet(var.slot_supernet_base, 8, k)
      transit_ip = cidrhost(var.private_lan_cidr, var.slot_transit_offset + k)
      gateway    = format("SlotGW%02d", k)
    }
  ]
  template_common = {
    SLOTS              = local.slots
    SLOT_SUPERNET_BASE = var.slot_supernet_base
    HUB_SERVICES       = var.hub_services
    # squid url_regex patterns per domain: plain HTTP on port 80 and CONNECT (HTTPS) on 443, domain and sub-domains.
    # Patterns containing ^ or \ are used verbatim by the OPNsense template; the list is comma-separated.
    # squid SSL_ports (CONNECT allowed) as OPNsense expects them: "port:label" entries
    PROXY_SSL_PORTS = join(",", [for p in var.proxy_connect_ports : format("%d:%s", p, lookup({ 443 = "https", 6514 = "syslog-tls", 12202 = "gelf-tls", 9200 = "opensearch" }, p, "custom"))])
    PROXY_ALLOWED_DOMAINS = join(",", flatten([for d in var.proxy_allowed_domains : [
      format("^http://([^/]*\\.)?%s(:80)?(/|$)", replace(d, ".", "\\.")),
      format("^([^/]*\\.)?%s:443$", replace(d, ".", "\\.")),
    ]]))
  }
}

########################################################################################
#   Attach Floating IP to OPNsense Primary
########################################################################################

resource "openstack_networking_floatingip_v2" "fw_fip" {
  depends_on = [openstack_networking_router_interface_v2.fw_wan_router_if]

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
    precondition {
      condition = var.slot_count == 0 || (
        cidrhost(var.private_wan_cidr, 0) != cidrhost(var.slot_supernet_base, 0) &&
        !startswith(var.private_wan_cidr, "10.") && !startswith(var.private_hasync_cidr, "10.") && !startswith(var.private_lan_cidr, "10.")
      ) || !startswith(var.slot_supernet_base, "10.")
      error_message = "With slot routing enabled, the hub WAN / LAN / HASYNC CIDRs must not overlap slot_supernet_base (default 10.0.0.0/8): use e.g. 172.16.x.x for WAN and HASYNC."
    }
    precondition {
      condition = alltrue([
        for c in [var.private_wan_cidr, var.private_hasync_cidr, var.private_lan_cidr] :
        !startswith(c, "172.17.") && !(startswith(c, "172.31.") && tonumber(split(".", c)[2]) < 128)
      ])
      error_message = "Hub WAN / LAN / HASYNC CIDRs must avoid 172.17.0.0/16 (Docker on Managed Kubernetes nodes) and 172.31.0.0/17 (Ext-Net gateway ports used by Floating IPs) — both reserved by OVHcloud."
    }
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
    local.template_common,
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
    local.template_common,
    var.template_extra_vars
  )))
}
