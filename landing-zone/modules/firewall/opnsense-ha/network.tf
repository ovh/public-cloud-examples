########################################################################################
#   Private WAN Network + Subnet
########################################################################################

resource "openstack_networking_network_v2" "fw_wan_net" {
  name                  = "opn-wan-net"
  admin_state_up        = true
  port_security_enabled = false
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.net_wan_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "fw_wan_subnet" {
  name            = "opn-wan-subnet"
  network_id      = openstack_networking_network_v2.fw_wan_net.id
  cidr            = var.private_wan_cidr
  enable_dhcp     = true
  allocation_pool {
    start = cidrhost(var.private_wan_cidr, 100)
    end   = cidrhost(var.private_wan_cidr, 200)
  }
  dns_nameservers = ["213.186.33.99"]
  no_gateway      = false
}

resource "openstack_networking_port_v2" "fw_wan_active_port" {
  name                  = "opn-wan-active-port"
  network_id            = openstack_networking_network_v2.fw_wan_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_wan_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_wan_subnet.cidr, 2)
  }
}

resource "openstack_networking_port_v2" "fw_wan_passive_port" {
  name                  = "opn-wan-passive-port"
  network_id            = openstack_networking_network_v2.fw_wan_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_wan_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_wan_subnet.cidr, 3)
  }
}

resource "openstack_networking_port_v2" "fw_wan_carp_vip" {
  name                  = "opn-wan-carp-vip"
  network_id            = openstack_networking_network_v2.fw_wan_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_wan_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_wan_subnet.cidr, 99)
  }
}

########################################################################################
#   Gateway | Public <-> Private WAN Network
########################################################################################

resource "ovh_cloud_project_gateway" "fw_wan_router" {
  service_name = var.os_tenant_id
  name         = "opn-wan-router"
  model        = "s"
  region       = var.os_region
  network_id   = openstack_networking_network_v2.fw_wan_net.id
  subnet_id    = openstack_networking_subnet_v2.fw_wan_subnet.id
}

########################################################################################
#   LAN Network + Subnet
########################################################################################

resource "openstack_networking_network_v2" "fw_lan_net" {
  name                  = "opn-lan-net"
  admin_state_up        = true
  port_security_enabled = false
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.net_lan_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "fw_lan_subnet" {
  name            = "opn-lan-subnet"
  network_id      = openstack_networking_network_v2.fw_lan_net.id
  cidr            = var.private_lan_cidr
  enable_dhcp     = true
  allocation_pool {
    start = cidrhost(var.private_lan_cidr, 100)
    end   = cidrhost(var.private_lan_cidr, 200)
  }
  dns_nameservers = ["213.186.33.99"]
  no_gateway      = false
}

resource "openstack_networking_port_v2" "fw_lan_active_port" {
  name                  = "opn-lan-active-port"
  network_id            = openstack_networking_network_v2.fw_lan_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_lan_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_lan_subnet.cidr, 2)
  }
}

resource "openstack_networking_port_v2" "fw_lan_passive_port" {
  name                  = "opn-lan-passive-port"
  network_id            = openstack_networking_network_v2.fw_lan_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_lan_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_lan_subnet.cidr, 3)
  }
}

resource "openstack_networking_port_v2" "fw_lan_carp_vip" {
  name                  = "opn-lan-carp-vip"
  network_id            = openstack_networking_network_v2.fw_lan_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_lan_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_lan_subnet.cidr, 99)
  }
}

########################################################################################
#   HA Sync Network + Subnet + Ports
########################################################################################

resource "openstack_networking_network_v2" "fw_hasync_net" {
  name                  = "opn-hasync-net"
  admin_state_up        = true
  port_security_enabled = false
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.net_hasync_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "fw_hasync_subnet" {
  name        = "opn-hasync-subnet"
  network_id  = openstack_networking_network_v2.fw_hasync_net.id
  cidr        = var.private_hasync_cidr
  enable_dhcp = false
  no_gateway  = true
}

resource "openstack_networking_port_v2" "fw_hasync_active_port" {
  name                  = "opn-hasync-active-port"
  network_id            = openstack_networking_network_v2.fw_hasync_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_hasync_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_hasync_subnet.cidr, 1)
  }
}

resource "openstack_networking_port_v2" "fw_hasync_passive_port" {
  name                  = "opn-hasync-passive-port"
  network_id            = openstack_networking_network_v2.fw_hasync_net.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.fw_hasync_subnet.id
    ip_address = cidrhost(openstack_networking_subnet_v2.fw_hasync_subnet.cidr, 2)
  }
}
