resource "openstack_networking_network_v2" "mononetwork" {
  for_each = { for o in var.multi : o.region => o }

  name           = var.common.mono_nw_name
  region         = each.key
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "monosubnet" {
  for_each = { for o in var.multi : o.region => o }

  network_id  = openstack_networking_network_v2.mononetwork[each.key].id
  name        = var.common.mono_subnet_name
  region      = each.key
  cidr        = each.value.mono_subnet_cidr
  enable_dhcp = true
  allocation_pool {
    start = each.value.mono_subnet_start
    end   = each.value.mono_subnet_end
  }
  no_gateway      = false
  dns_nameservers = ["1.1.1.1", "1.0.0.1"]
}

resource "openstack_networking_router_v2" "router" {
  for_each = { for o in var.multi : o.region => o }

  region              = each.key
  name                = var.common.router_name
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext_net[each.key].id
}

resource "openstack_networking_router_interface_v2" "router_interface_mono" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.router[each.key].id
  subnet_id = openstack_networking_subnet_v2.monosubnet[each.key].id
}

resource "ovh_cloud_project_network_private" "multinetwork" {
  service_name = var.service_name
  name         = var.common.multi_nw_name
  vlan_id      = var.common.multi_nw_vlan_id
  regions      = var.common.regions
}

resource "openstack_networking_subnet_v2" "multisubnet" {
  for_each = { for o in var.multi : o.region => o }

  # tflint-ignore: terraform_deprecated_index
  network_id  = tolist(ovh_cloud_project_network_private.multinetwork.regions_attributes)[index(ovh_cloud_project_network_private.multinetwork.regions_attributes.*.region, each.key)].openstackid
  name        = var.common.multi_subnet_name
  region      = each.key
  cidr        = var.common.multi_subnet_cidr
  enable_dhcp = false
  gateway_ip  = each.value.router_multi_nw_ip
  allocation_pool {
    start = each.value.multi_subnet_start
    end   = each.value.multi_subnet_end
  }
}

resource "openstack_networking_router_interface_v2" "router_interface_multi" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.router[each.key].id
  subnet_id = openstack_networking_subnet_v2.multisubnet[each.key].id
}

/*
resource "openstack_networking_router_route_v2" "route01" {
  for_each = { for o in var.multi : o.region => o }

  region           = each.key
  router_id        = openstack_networking_router_v2.router[each.key].id
  destination_cidr = each.value.dest_route1
  next_hop         = each.value.next_hop_route1
}

resource "openstack_networking_router_route_v2" "route02" {
  for_each = { for o in var.multi : o.region => o }

  region           = each.key
  router_id        = openstack_networking_router_v2.router[each.key].id
  destination_cidr = each.value.dest_route2
  next_hop         = each.value.next_hop_route2
}
*/
