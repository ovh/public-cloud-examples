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
  name        = "opn-wan-subnet"
  network_id  = openstack_networking_network_v2.fw_wan_net.id
  cidr        = var.private_wan_cidr
  enable_dhcp = true
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
#   A Neutron router attached to Ext-Net is what the OVHcloud console calls a "Gateway"
#   (size S by default). Created with OpenStack credentials only — no OVH API token.
#   The router takes the subnet gateway IP (.1), which the templates use as WAN_GATEWAY_IP.
########################################################################################

data "openstack_networking_network_v2" "ext_net" {
  name = "Ext-Net"
}

resource "openstack_networking_router_v2" "fw_wan_router" {
  name                = "opn-wan-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "fw_wan_router_if" {
  router_id = openstack_networking_router_v2.fw_wan_router.id
  subnet_id = openstack_networking_subnet_v2.fw_wan_subnet.id
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
  name        = "opn-lan-subnet"
  network_id  = openstack_networking_network_v2.fw_lan_net.id
  cidr        = var.private_lan_cidr
  enable_dhcp = true
  allocation_pool {
    start = cidrhost(var.private_lan_cidr, 100)
    end   = cidrhost(var.private_lan_cidr, 200)
  }
  dns_nameservers = ["213.186.33.99"]
  # The LAN CARP VIP (.99) is the workloads' default gateway. Declaring it as the subnet
  # gateway makes Neutron DHCP hand out the right default route and DNS host route,
  # so a plain DHCP client on the LAN reaches the Internet without manual configuration.
  gateway_ip = cidrhost(var.private_lan_cidr, 99)
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
