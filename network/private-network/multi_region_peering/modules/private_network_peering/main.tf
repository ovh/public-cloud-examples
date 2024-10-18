
resource "openstack_networking_network_v2" "peering_private_network" {
  for_each = var.networks_to_peer 

  region    = each.key
  
  name   = "${var.resource_prefix}_peering_pn_${each.key}"
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.peering_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "peering_subnet" {
  for_each = var.networks_to_peer

  region    = each.key
  name       = "${var.resource_prefix}_peering_subnet_${each.key}"
  network_id = openstack_networking_network_v2.peering_private_network[each.key].id
  cidr       = var.peering_cidr_block
  gateway_ip = each.value.gateway_ip
  ip_version = 4
  allocation_pool {
    start = each.value.allocation_pool.start
    end   = each.value.allocation_pool.end
  }
}


resource "openstack_networking_router_interface_v2" "peering_router_itf" {
  for_each = var.networks_to_peer

  region   = each.key
  router_id = each.value.router_id
  subnet_id = openstack_networking_subnet_v2.peering_subnet[each.key].id
}



resource "openstack_networking_router_route_v2" "static_route_1" {
  for_each = var.networks_to_peer

  region    = each.key
  router_id        = each.value.router_id
  destination_cidr = each.value.route_cidr
  next_hop         = each.value.route_next_hop

  depends_on = [
    openstack_networking_router_interface_v2.peering_router_itf
  ]
}

