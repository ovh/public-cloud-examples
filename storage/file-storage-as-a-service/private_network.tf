resource "ovh_cloud_project_network_private" "private-net" {
  name    = "${var.demo_name}-private-network"
  vlan_id = var.private_network_vlan_id
  regions = ["${var.region_name}"]
}

resource "ovh_cloud_project_network_private_subnet_v2" "private-subnet" {
  network_id                      = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
  name                            = "${var.demo_name}-private-subnet"
  region                          = var.region_name
  dns_nameservers                 = ["1.1.1.1"]
  cidr                            = "10.0.0.0/24"
  dhcp                            = true
  enable_gateway_ip               = true
}

resource "ovh_cloud_project_gateway" "gateway" {
  name       = "${var.demo_name}-gateway"
  model      = var.gateway_size
  region     = var.region_name
  network_id = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
  subnet_id  = ovh_cloud_project_network_private_subnet_v2.private-subnet.id
}