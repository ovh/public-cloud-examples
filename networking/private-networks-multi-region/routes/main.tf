resource "openstack_networking_router_route_v2" "route01" {
  for_each = { for o in var.routes : o.region => o }

  region           = each.key
  router_id        = data.openstack_networking_router_v2.router[each.key].id
  destination_cidr = each.value.dest_route1
  next_hop         = each.value.next_hop_route1
}

resource "openstack_networking_router_route_v2" "route02" {
  for_each = { for o in var.routes : o.region => o }

  region           = each.key
  router_id        = data.openstack_networking_router_v2.router[each.key].id
  destination_cidr = each.value.dest_route2
  next_hop         = each.value.next_hop_route2
}
