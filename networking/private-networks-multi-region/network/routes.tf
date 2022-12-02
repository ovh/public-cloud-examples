resource "openstack_networking_router_route_v2" "routeFrontToBack" {
  for_each = { for o in var.multi : o.region => o }

  region           = each.key
  router_id        = openstack_networking_router_v2.frontrouter[each.key].id
  destination_cidr = var.common.backSubnetCIDR
  next_hop         = each.value.backRouterFrontIP
}
