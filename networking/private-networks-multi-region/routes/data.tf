data "openstack_networking_router_v2" "router" {
  for_each = { for o in var.routes : o.region => o }

  name   = "router"
  region = each.key
}
