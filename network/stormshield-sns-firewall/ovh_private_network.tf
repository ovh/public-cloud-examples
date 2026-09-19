resource "openstack_networking_network_v2" "private-net-ext" {
  name = "${var.ovh_os_instance_name}-ext"
  region     = var.ovh_os_instance_region
  admin_state_up = "true"
  port_security_enabled = "false"
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = "0"
  }
}

resource "openstack_networking_subnet_v2" "private-subnet-ext" {
  name = "${var.ovh_os_instance_name}-ext"
  network_id  = openstack_networking_network_v2.private-net-ext.id
  region      = var.ovh_os_instance_region
  cidr        = "192.168.1.0/29"
  enable_dhcp = true
  allocation_pool {
      start = "192.168.1.2"
      end   = "192.168.1.6"
  }
  no_gateway = false
}

data "openstack_networking_network_v2" "ext-net" {
  name    = "Ext-Net"
  region  = var.ovh_os_instance_region
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.ovh_os_instance_name}-router"
  region  = var.ovh_os_instance_region
  admin_state_up      = true
  external_network_id = ""
}

resource "openstack_networking_router_interface_v2" "router-interface" {
  region  = var.ovh_os_instance_region
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private-subnet-ext.id
}

resource "openstack_networking_network_v2" "private-net-workload" {
  name = "${var.ovh_os_instance_name}-workload"
  region     = var.ovh_os_instance_region
  admin_state_up = "true"
  port_security_enabled = "false"
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.ovh_os_private_network_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "private-subnet-workload" {
  name = "${var.ovh_os_instance_name}-workload"
  network_id  = openstack_networking_network_v2.private-net-workload.id
  region      = var.ovh_os_instance_region
  cidr        = "10.200.0.0/16"
  enable_dhcp = true
  allocation_pool {
      start = "10.200.0.2"
      end   = "10.200.0.254"
  }
  dns_nameservers = ["213.186.33.99"]
  no_gateway = false
}

resource "openstack_networking_network_v2" "private-net-ha" {
  name = "${var.ovh_os_instance_name}-ha"
  region     = var.ovh_os_instance_region
  admin_state_up = "true"
  port_security_enabled = "false"
  value_specs = {
    "provider:network_type"    = "vrack"
    "provider:segmentation_id" = var.ovh_os_private_network_ha_vlan_id
  }
}

resource "openstack_networking_subnet_v2" "private-subnet-ha" {
  name = "${var.ovh_os_instance_name}-ha"
  network_id  = openstack_networking_network_v2.private-net-ha.id
  region      = var.ovh_os_instance_region
  cidr        = "192.168.2.0/29"
  enable_dhcp = true
  no_gateway = true
}