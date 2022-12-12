resource "ovh_cloud_project_network_private" "backnetwork" {
  service_name = var.serviceName
  name         = var.common.backNwName
  vlan_id      = var.common.backNwVlanId
  regions      = var.common.regions
}

resource "openstack_networking_subnet_v2" "backsubnet" {
  for_each = { for o in var.multi : o.region => o }

  network_id  = tolist(ovh_cloud_project_network_private.backnetwork.regions_attributes)[index(ovh_cloud_project_network_private.backnetwork.regions_attributes.*.region, each.key)].openstackid
  region      = each.key
  cidr        = var.common.backSubnetCIDR
  enable_dhcp = false
  gateway_ip  = each.value.backRouterBackIP
  allocation_pool {
    start = each.value.backSubnetStart
    end   = each.value.backSubnetEnd
  }
}

resource "openstack_networking_router_v2" "backrouter" {
  for_each = { for o in var.multi : o.region => o }

  region         = each.key
  name           = var.common.backRouterName
  admin_state_up = true
}

/*
resource "openstack_networking_router_interface_v2" "backRouterInterfaceBack" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.backrouter[each.key].id
  subnet_id = openstack_networking_subnet_v2.backsubnet[each.key].id
}
*/

resource "openstack_networking_port_v2" "backRouterPortFront" {
  for_each = { for o in var.multi : o.region => o }

  region         = each.key
  name           = "frontPort"
  network_id     = openstack_networking_network_v2.frontnetwork[each.key].id
  admin_state_up = true
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.frontsubnet[each.key].id
    ip_address = each.value.backRouterFrontIP
  }
}

resource "openstack_networking_router_interface_v2" "backRouterInterfaceFront" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.backrouter[each.key].id
  port_id   = openstack_networking_port_v2.backRouterPortFront[each.key].id
}



resource "openstack_networking_port_v2" "backRouterPortBack" {
  for_each = { for o in var.multi : o.region => o }

  region         = each.key
  name           = "backPort"
  network_id     = openstack_networking_subnet_v2.backsubnet[each.key].network_id
  admin_state_up = true
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.backsubnet[each.key].id
    ip_address = each.value.backRouterBackIP
  }
}

resource "openstack_networking_router_interface_v2" "backRouterInterfaceBack" {
  for_each = { for o in var.multi : o.region => o }

  region    = each.key
  router_id = openstack_networking_router_v2.backrouter[each.key].id
  port_id   = openstack_networking_port_v2.backRouterPortBack[each.key].id
}
