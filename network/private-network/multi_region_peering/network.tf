


########################################################################################
#     data sources
########################################################################################

data "openstack_networking_network_v2" "ext_net_region1" {
  name     = var.external_network
  region   = var.region1
  external = true
  depends_on = [
    ovh_cloud_project_user.user
  ]
}

data "openstack_networking_network_v2" "ext_net_region2" {
  name     = var.external_network
  region   = var.region2
  external = true
  depends_on = [
    ovh_cloud_project_user.user
  ]
}


########################################################################################
#     Region 1
########################################################################################

# Network and Subnet for region1
resource "openstack_networking_network_v2" "local_vlan_region1" {
  region = var.region1
  name   = "${var.resource_prefix}_local_vlan_${var.region1}"
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.region1_vlanid
  }

}
resource "openstack_networking_subnet_v2" "local_subnet_region1" {
  region          = var.region1
  network_id      = openstack_networking_network_v2.local_vlan_region1.id
  name            = "${var.resource_prefix}_local_subnet_${var.region1}"
  cidr            = "10.0.1.0/24"
  gateway_ip      = "10.0.1.1"
  dns_nameservers = [var.default_dns_resolver]
  ip_version      = 4
}
resource "openstack_networking_router_v2" "router1" {
  region = var.region1

  external_network_id = data.openstack_networking_network_v2.ext_net_region1.id
  name                = "${var.resource_prefix}_router_${var.region1}"
}

resource "openstack_networking_router_interface_v2" "local_router1_itf" {
  region    = var.region1
  router_id = openstack_networking_router_v2.router1.id
  subnet_id = openstack_networking_subnet_v2.local_subnet_region1.id
}


########################################################################################
#     Region2
########################################################################################
resource "openstack_networking_network_v2" "local_vlan_region2" {
  region = var.region2
  name   = "${var.resource_prefix}_local_vlan_${var.region2}"
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.region2_vlanid
  }
}

resource "openstack_networking_subnet_v2" "local_subnet_region2" {
  region          = var.region2
  name            = "${var.resource_prefix}_local_subnet_${var.region2}"
  network_id      = openstack_networking_network_v2.local_vlan_region2.id
  cidr            = "10.0.2.0/24"
  ip_version      = 4
  gateway_ip      = "10.0.2.1"
  dns_nameservers = [var.default_dns_resolver]
}

resource "openstack_networking_router_v2" "router2" {
  region              = var.region2
  external_network_id = data.openstack_networking_network_v2.ext_net_region2.id
  name                = "${var.resource_prefix}_router_${var.region2}"
}

resource "openstack_networking_router_interface_v2" "local_router2_itf" {
  region    = var.region2
  router_id = openstack_networking_router_v2.router2.id
  subnet_id = openstack_networking_subnet_v2.local_subnet_region2.id
}



########################################################################################
#     Peering
########################################################################################
module "peering" {
  source = "./modules/private_network_peering"
  networks_to_peer = {
    "${var.region1}" = {
      subnet_id  = openstack_networking_subnet_v2.local_subnet_region1.id
      router_id  = openstack_networking_router_v2.router1.id
      gateway_ip = "10.42.0.1"
      allocation_pool = { #minimum 5 IPs is request in the pool 
        start = "10.42.0.2"
        end   = "10.42.0.7"
      }
      route_cidr     = openstack_networking_subnet_v2.local_subnet_region2.cidr
      route_next_hop = "10.42.0.14"
    },
    "${var.region2}" = {
      subnet_id  = openstack_networking_subnet_v2.local_subnet_region2.id
      router_id  = openstack_networking_router_v2.router2.id
      gateway_ip = "10.42.0.14"
      allocation_pool = {
        start = "10.42.0.8"
        end   = "10.42.0.13"
      }
      route_cidr     = openstack_networking_subnet_v2.local_subnet_region1.cidr
      route_next_hop = "10.42.0.1"
    }
  }

}
