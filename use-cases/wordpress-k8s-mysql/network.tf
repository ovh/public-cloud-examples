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
  model      = "l"
  region     = var.kubernetes.region
  network_id = tolist(ovh_cloud_project_network_private.private_network.regions_attributes[*].openstackid)[0]
  subnet_id  = ovh_cloud_project_network_private_subnet.subnet.id
}
