resource "ovh_cloud_project_network_private" "private_network" {
  name    = "${var.resource_prefix}network"
  regions = [var.kubernetes.region]
}

resource "ovh_cloud_project_network_private_subnet" "subnet" {
  network_id = ovh_cloud_project_network_private.private_network.id
  region     = var.kubernetes.region
  start      = "10.0.0.100"
  end        = "10.0.0.200"
  network    = "10.0.0.0/24"
  dhcp       = true
  no_gateway = false
}

resource "ovh_cloud_project_gateway" "gateway" {
  name       = "${var.resource_prefix}gateway"
  model      = "s"
  region     = var.kubernetes.region
  network_id = tolist(ovh_cloud_project_network_private.private_network.regions_attributes[*].openstackid)[0]
  subnet_id  = ovh_cloud_project_network_private_subnet.subnet.id
}


/*data "openstack_networking_network_v2" "ext_net" {
  name     = "Ext-Net"
  external = true
}
resource "openstack_networking_network_v2" "network" {
  name = "private_network"
}


resource "openstack_networking_subnet_v2" "subnet" {
  name            = "subnet"
  network_id      = openstack_networking_network_v2.network.id
  cidr            = "10.0.0.0/24"
  gateway_ip      = "10.0.0.254"
  dns_nameservers = ["213.186.33.99"]
  ip_version      = 4
}

resource "openstack_networking_router_v2" "router" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.ext_net.id
}

resource "openstack_networking_router_interface_v2" "router_itf_priv" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}*/