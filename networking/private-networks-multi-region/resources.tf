resource "openstack_networking_network_v2" "frontnetwork" {
  for_each		= { for o in var.z : o.region => o }

  name           	= var.common.frontNwName
  region		= "${each.key}"
  admin_state_up 	= "true"
}

resource "openstack_networking_subnet_v2" "frontsubnet" {
  for_each              = { for o in var.z : o.region => o }

  network_id		= openstack_networking_network_v2.frontnetwork[each.key].id
  name                 	= var.common.frontSubnetName
  region               	= "${each.key}"
  cidr                 	= "${each.value.frontSubnetCIDR}"
  enable_dhcp          = false
  no_gateway           = false
  dns_nameservers      = ["1.1.1.1","1.0.0.1"]
}

resource "openstack_networking_router_v2" "frontrouter" {
  for_each              = { for o in var.z : o.region => o }

  region		= "${each.key}"
  name                  = var.common.frontRouterName
  admin_state_up        = true
  external_network_id   = "${data.openstack_networking_network_v2.Ext-Net[each.key].id}"
}

resource "openstack_networking_router_interface_v2" "frontRouterInterface" {
  for_each              = { for o in var.z : o.region => o }

  region                = "${each.key}"
  router_id             = "${openstack_networking_router_v2.frontrouter[each.key].id}"
  subnet_id             = "${openstack_networking_subnet_v2.frontsubnet[each.key].id}"
}

resource "ovh_cloud_project_network_private" "backnetwork" {
  service_name 	= var.serviceName
  name         	= var.common.backNwName
  vlan_id	= var.common.backNwVlanId
  regions      	= var.common.regions
}

resource "openstack_networking_subnet_v2" "backsubnet" {
  for_each              = { for o in var.z : o.region => o }

  network_id		= tolist(ovh_cloud_project_network_private.backnetwork.regions_attributes)[index(ovh_cloud_project_network_private.backnetwork.regions_attributes.*.region, each.key)].openstackid
  region		= "${each.key}"
  cidr                  = "${each.value.backSubnetCIDR}"
  enable_dhcp          	= false
  no_gateway           	= false
  dns_nameservers      	= ["1.1.1.1","1.0.0.1"]
}

resource "openstack_networking_router_v2" "backrouter" {
  for_each              = { for o in var.z : o.region => o }

  region                = "${each.key}"
  name                  = var.common.backRouterName
  admin_state_up        = true
}

resource "openstack_networking_router_interface_v2" "backRouterInterfaceBack" {
  for_each              = { for o in var.z : o.region => o }

  region                = "${each.key}"
  router_id             = "${openstack_networking_router_v2.backrouter[each.key].id}"
  subnet_id             = "${openstack_networking_subnet_v2.backsubnet[each.key].id}"
}

resource "openstack_networking_port_v2" "backRouterPortFront" {
  for_each              = { for o in var.z : o.region => o }

  region		= "${each.key}"
  name           	= var.common.portName
  network_id     	= "${openstack_networking_network_v2.frontnetwork[each.key].id}"
  admin_state_up 	= true
  fixed_ip		{
		subnet_id	= "${openstack_networking_subnet_v2.frontsubnet[each.key].id}"
		ip_address	= "${each.value.backRouterFrontIP}"
		}
}

resource "openstack_networking_router_interface_v2" "backRouterInterfaceFront" {
  for_each              = { for o in var.z : o.region => o }

  region                = "${each.key}"
  router_id             = "${openstack_networking_router_v2.backrouter[each.key].id}"
  port_id             	= "${openstack_networking_port_v2.backRouterPortFront[each.key].id}"
}
