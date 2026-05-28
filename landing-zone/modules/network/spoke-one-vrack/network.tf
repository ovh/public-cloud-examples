########################################################################################
#   Transit Network (VLAN 200 — same L2 as the hub LAN, shared through the vRack)
########################################################################################

resource "openstack_networking_network_v2" "transit" {
  name                  = "${var.spoke_name}-transit-net"
  admin_state_up        = true
  port_security_enabled = false
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.hub_lan_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "transit" {
  name        = "${var.spoke_name}-transit-subnet"
  network_id  = openstack_networking_network_v2.transit.id
  cidr        = var.hub_lan_cidr
  enable_dhcp = false   # CRITICAL: DHCP is managed by the hub on this L2
  no_gateway  = true
}

# Port with a fixed IP for the spoke router on the transit VLAN
resource "openstack_networking_port_v2" "transit_router_port" {
  name                  = "${var.spoke_name}-transit-router-port"
  network_id            = openstack_networking_network_v2.transit.id
  admin_state_up        = true
  port_security_enabled = false

  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.transit.id
    ip_address = var.transit_router_ip
  }
}

########################################################################################
#   Spoke LAN Networks (for_each over var.networks)
########################################################################################

resource "openstack_networking_network_v2" "spoke_lans" {
  for_each       = var.networks
  name           = "${var.spoke_name}-lan-${each.key}-net"
  admin_state_up = true
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = each.value.vlan_id
  }
}

resource "openstack_networking_subnet_v2" "spoke_lans" {
  for_each        = var.networks
  name            = "${var.spoke_name}-lan-${each.key}-subnet"
  network_id      = openstack_networking_network_v2.spoke_lans[each.key].id
  cidr            = each.value.cidr
  enable_dhcp     = true
  dns_nameservers = ["213.186.33.99"]
  allocation_pool {
    start = cidrhost(each.value.cidr, 10)
    end   = cidrhost(each.value.cidr, 200)
  }
}
