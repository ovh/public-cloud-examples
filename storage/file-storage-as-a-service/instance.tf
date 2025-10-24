resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.demo_name}-keypair"
  region     = var.region_name
  public_key = var.ssh_public_key
}

resource "openstack_networking_port_v2" "port" {
  name           = "${var.demo_name}-port"
  region         = var.region_name
  network_id     = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
  admin_state_up = "true"

  fixed_ip {
    subnet_id = ovh_cloud_project_network_private_subnet_v2.private-subnet.id
  }
}

resource "openstack_compute_instance_v2" "instance" {
  name            = "${var.demo_name}-instance"
  region          = var.region_name
  image_name      = var.instance_image_name
  flavor_name     = var.instance_flavor_name
  key_pair        = openstack_compute_keypair_v2.keypair.name

  user_data = base64encode(templatefile("templates/mount-nfs-share.tpl",
    {
      SHARE_EXPORT_PATH=openstack_sharedfilesystem_share_v2.share.export_locations[0].path
    }
  ))

  network {
    port = openstack_networking_port_v2.port.id
  }

  depends_on = [openstack_sharedfilesystem_share_v2.share]
}

resource "openstack_networking_floatingip_v2" "floating-ip" {
  pool    = "Ext-Net"
  region  = var.region_name
}

resource "openstack_networking_floatingip_associate_v2" "floating-ip-association" {
  region      = var.region_name
  floating_ip = openstack_networking_floatingip_v2.floating-ip.address
  port_id     = openstack_networking_port_v2.port.id

  depends_on = [ovh_cloud_project_gateway.gateway]
}

output "instance_ip" {
  value = openstack_networking_floatingip_v2.floating-ip.address
}