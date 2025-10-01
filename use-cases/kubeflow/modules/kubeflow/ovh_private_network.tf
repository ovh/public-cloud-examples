resource "ovh_cloud_project_network_private" "private-net" {
  name         = "${var.ovh_kube_cluster_name}-private-network"
  vlan_id      = "${var.ovh_os_private_network_vlan_id}"
  regions      = ["${var.ovh_os_region_name}"]
}

resource "ovh_cloud_project_network_private_subnet" "private-subnet" {
  network_id   = ovh_cloud_project_network_private.private-net.id
  region       = "${var.ovh_os_region_name}"
  start        = "192.168.168.2"
  end          = "192.168.168.254"
  network      = "192.168.168.0/24"
  dhcp         = true
  no_gateway   = false
}

resource "ovh_cloud_project_gateway" "gateway" {
  name          = "${var.ovh_kube_cluster_name}-gateway"
  model         = "${var.ovh_gateway_size}"
  region        = "${var.ovh_os_region_name}"
  network_id    = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
  subnet_id     = ovh_cloud_project_network_private_subnet.private-subnet.id
}