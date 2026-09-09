locals {
  supernet   = cidrsubnet(var.slot_supernet_base, 8, var.slot)
  transit_ip = cidrhost(var.hub_lan_cidr, var.slot_transit_offset + var.slot)
  lans = {
    for name, idx in var.networks : name => {
      cidr    = cidrsubnet(local.supernet, 8, idx)
      vlan_id = var.slot_vlan_base + 10 * var.slot + idx
    }
  }
}

########################################################################################
#   Transit: same VLAN and subnet as the hub LAN, DHCP left to the hub
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
  enable_dhcp = false
  no_gateway  = true
}

resource "openstack_networking_port_v2" "transit_router_port" {
  name                  = "${var.spoke_name}-transit-router-port"
  network_id            = openstack_networking_network_v2.transit.id
  admin_state_up        = true
  port_security_enabled = false
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.transit.id
    ip_address = local.transit_ip
  }
}

########################################################################################
#   Spoke LANs: DHCP hands out the router as gateway and the hub VIP as DNS
########################################################################################

resource "openstack_networking_network_v2" "lan" {
  for_each       = local.lans
  name           = "${var.spoke_name}-lan-${each.key}-net"
  admin_state_up = true
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = each.value.vlan_id
  }
}

resource "openstack_networking_subnet_v2" "lan" {
  for_each        = local.lans
  name            = "${var.spoke_name}-lan-${each.key}-subnet"
  network_id      = openstack_networking_network_v2.lan[each.key].id
  cidr            = each.value.cidr
  enable_dhcp     = true
  dns_nameservers = [var.hub_lan_carp_ip]
  allocation_pool {
    start = cidrhost(each.value.cidr, 10)
    end   = cidrhost(each.value.cidr, 200)
  }
}

########################################################################################
#   Router: no external gateway — everything leaves through the hub VIP
########################################################################################

resource "openstack_networking_router_v2" "spoke" {
  name           = "${var.spoke_name}-router"
  admin_state_up = true

  lifecycle {
    precondition {
      condition     = var.allow_kube_default_cidr_overlap || !contains([2, 3], var.slot)
      error_message = "Slots 2 and 3 (10.2.0.0/16, 10.3.0.0/16) are the default pod/service CIDRs of OVHcloud Managed Kubernetes and are reserved; set allow_kube_default_cidr_overlap = true only for a spoke that will never meet a cluster left on default CIDRs."
    }
  }
}

resource "openstack_networking_router_interface_v2" "transit" {
  router_id = openstack_networking_router_v2.spoke.id
  port_id   = openstack_networking_port_v2.transit_router_port.id
}

resource "openstack_networking_router_interface_v2" "lan" {
  for_each  = local.lans
  router_id = openstack_networking_router_v2.spoke.id
  subnet_id = openstack_networking_subnet_v2.lan[each.key].id
}

resource "openstack_networking_router_route_v2" "default" {
  router_id        = openstack_networking_router_v2.spoke.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = var.hub_lan_carp_ip
  depends_on       = [openstack_networking_router_interface_v2.transit]
}
