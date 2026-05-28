resource "openstack_networking_router_v2" "spoke" {
  name           = "${var.spoke_name}-router"
  admin_state_up = true
  # No external_network_id — Internet routing goes through the hub via the default route
}

# Attach the router to the transit through the fixed port
resource "openstack_networking_router_interface_v2" "transit" {
  router_id = openstack_networking_router_v2.spoke.id
  port_id   = openstack_networking_port_v2.transit_router_port.id
}

# Attach the router to each spoke LAN
resource "openstack_networking_router_interface_v2" "spoke_lans" {
  for_each  = var.networks
  router_id = openstack_networking_router_v2.spoke.id
  subnet_id = openstack_networking_subnet_v2.spoke_lans[each.key].id
}

# Default route → hub LAN CARP VIP
resource "openstack_networking_router_route_v2" "default" {
  router_id        = openstack_networking_router_v2.spoke.id
  destination_cidr = "0.0.0.0/0"
  next_hop         = var.hub_lan_carp_ip

  depends_on = [openstack_networking_router_interface_v2.transit]
}
