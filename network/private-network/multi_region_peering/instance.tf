########################################################################################
#     Instances
########################################################################################

resource "openstack_compute_keypair_v2" "keypair_region1" {
  region     = var.region1
  name       = "${var.resource_prefix}_keypair_region1"
  public_key = file(var.public_key_path)
}

resource "openstack_compute_keypair_v2" "keypair_region2" {
  region     = var.region2
  name       = "${var.resource_prefix}_keypair_region2"
  public_key = file(var.public_key_path)
}

resource "openstack_compute_instance_v2" "instance_client_region1" {
  region      = var.region1
  name        = "${var.resource_prefix}_instance_client_${var.region1}"
  image_name  = var.image_name
  flavor_name = var.instance_flavor
  key_pair    = openstack_compute_keypair_v2.keypair_region1.id
  user_data   = file("cloud-init-client.yaml")
  network {
    port = openstack_networking_port_v2.port1.id
  }
  lifecycle {
    ignore_changes = [
      image_name
    ]
  }
}
resource "openstack_networking_floatingip_v2" "fip1" {
  region = var.region1
  pool   = data.openstack_networking_network_v2.ext_net_region1.name
}

resource "openstack_networking_port_v2" "port1" {
  region     = var.region1
  network_id = openstack_networking_network_v2.local_vlan_region1.id
  depends_on = [
    # we need the subnet to be created before the port, opentofu creates the 2 concurrently by default
    openstack_networking_subnet_v2.local_subnet_region1
  ]
}

resource "openstack_networking_floatingip_associate_v2" "association1" {
  region      = var.region1
  floating_ip = openstack_networking_floatingip_v2.fip1.address
  port_id     = openstack_networking_port_v2.port1.id
  depends_on = [
    openstack_networking_router_interface_v2.local_router1_itf
  ]
}


resource "openstack_compute_instance_v2" "instance_server_region1" {
  region      = var.region1
  name        = "${var.resource_prefix}_instance_server_${var.region1}"
  image_name  = var.image_name
  flavor_name = var.instance_flavor
  key_pair    = openstack_compute_keypair_v2.keypair_region1.id
  user_data   = file("cloud-init-server.yaml")
  network {
    port = openstack_networking_port_v2.port12.id
  }
  lifecycle {
    ignore_changes = [
      image_name
    ]
  }
}

resource "openstack_networking_port_v2" "port12" {
  region     = var.region1
  network_id = openstack_networking_network_v2.local_vlan_region1.id
  depends_on = [
    # we need the subnet to be created before the port, opentofu creates the 2 concurrently by default
    openstack_networking_subnet_v2.local_subnet_region1
  ]
}


resource "openstack_networking_port_v2" "port2" {
  region     = var.region2
  network_id = openstack_networking_network_v2.local_vlan_region2.id
  depends_on = [
    # we need the subnet to be created before the port, opentofu creates the 2 concurrently by default
    openstack_networking_subnet_v2.local_subnet_region1
  ]
}

resource "openstack_compute_instance_v2" "instance_server_region2" {
  region      = var.region2
  name        = "${var.resource_prefix}_instance_server_${var.region2}"
  image_name  = var.image_name
  flavor_name = var.instance_flavor
  key_pair    = openstack_compute_keypair_v2.keypair_region2.id
  user_data   = file("cloud-init-server.yaml")
  network {
    port = openstack_networking_port_v2.port2.id
  }
  lifecycle {
    ignore_changes = [
      image_name
    ]
  }
}

resource "openstack_networking_floatingip_v2" "fip2" {
  region = var.region2
  pool   = data.openstack_networking_network_v2.ext_net_region2.name
}

resource "openstack_networking_floatingip_associate_v2" "association2" {
  region      = var.region2
  floating_ip = openstack_networking_floatingip_v2.fip2.address
  port_id     = openstack_networking_port_v2.port2.id
  depends_on = [
    openstack_networking_router_interface_v2.local_router2_itf
  ]
}
