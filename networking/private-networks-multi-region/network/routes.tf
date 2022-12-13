resource "openstack_networking_router_route_v2" "route01_a" {
  region           = "GRA9"
  router_id        = openstack_networking_router_v2.backrouter["GRA9"].id
  destination_cidr = "192.168.20.0/24"
  next_hop         = "172.16.64.1"
}

resource "openstack_networking_router_route_v2" "route01_b" {
  region           = "GRA9"
  router_id        = openstack_networking_router_v2.backrouter["GRA9"].id
  destination_cidr = "192.168.30.0/24"
  next_hop         = "172.16.128.1"
}

resource "openstack_networking_router_route_v2" "route02_a" {
  region           = "GRA7"
  router_id        = openstack_networking_router_v2.backrouter["GRA7"].id
  destination_cidr = "192.168.10.0/24"
  next_hop         = "172.16.0.1"
}

resource "openstack_networking_router_route_v2" "route02_b" {
  region           = "GRA7"
  router_id        = openstack_networking_router_v2.backrouter["GRA7"].id
  destination_cidr = "192.168.30.0/24"
  next_hop         = "172.16.128.1"
}

resource "openstack_networking_router_route_v2" "route03_a" {
  region           = "SBG5"
  router_id        = openstack_networking_router_v2.backrouter["SBG5"].id
  destination_cidr = "192.168.10.0/24"
  next_hop         = "172.16.0.1"
}

resource "openstack_networking_router_route_v2" "route03_b" {
  region           = "SBG5"
  router_id        = openstack_networking_router_v2.backrouter["SBG5"].id
  destination_cidr = "192.168.20.0/24"
  next_hop         = "172.16.64.1"
}
