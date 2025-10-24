resource "openstack_sharedfilesystem_sharenetwork_v2" "sharenetwork" {
  name              = "${var.demo_name}-share-network"
  description       = "${var.demo_name} share network"
  region            = var.region_name
  neutron_net_id    = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
  neutron_subnet_id = ovh_cloud_project_network_private_subnet_v2.private-subnet.id
}

resource "openstack_sharedfilesystem_share_v2" "share" {
  name             = "${var.demo_name}-share"
  description      = "${var.demo_name} share"
  region           = var.region_name
  share_type       = "generic_0"
  share_proto      = "NFS"
  size             = var.share_size
  share_network_id = openstack_sharedfilesystem_sharenetwork_v2.sharenetwork.id
}

resource "openstack_sharedfilesystem_share_access_v2" "share_access" {
  share_id     = openstack_sharedfilesystem_share_v2.share.id
  region       = var.region_name
  access_type  = "ip"
  access_to    = openstack_networking_port_v2.port.all_fixed_ips[0]
  access_level = "rw"
}