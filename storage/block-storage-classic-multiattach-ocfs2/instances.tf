resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.demo_name}-keypair"
  region     = var.region_name
  public_key = var.ssh_public_key
}

resource "openstack_networking_port_v2" "port" {
  count          = 3

  name           = "${var.demo_name}-port-${count.index + 1}"
  region         = var.region_name
  network_id     = tolist(ovh_cloud_project_network_private.private-net.regions_attributes[*].openstackid)[0]
  admin_state_up = "true"

  fixed_ip {
    subnet_id = ovh_cloud_project_network_private_subnet_v2.private-subnet.id
  }
}

resource "openstack_compute_instance_v2" "instance" {
  count           = 3
  name            = "${var.demo_name}-instance-${count.index + 1}"
  region          = var.region_name
  image_name      = var.instance_image_name
  flavor_name     = var.instance_flavor_name
  key_pair        = openstack_compute_keypair_v2.keypair.name

  user_data = base64encode(templatefile("templates/ocfs2-cloud-config.tpl",
    {
      SERVER_1_NAME="${var.demo_name}-instance-1"
      SERVER_2_NAME="${var.demo_name}-instance-2"
      SERVER_3_NAME="${var.demo_name}-instance-3"
      SERVER_1_IP=openstack_networking_port_v2.port[0].all_fixed_ips[0]
      SERVER_2_IP=openstack_networking_port_v2.port[1].all_fixed_ips[0]
      SERVER_3_IP=openstack_networking_port_v2.port[2].all_fixed_ips[0]
    }
  ))

  network {
    port = openstack_networking_port_v2.port[count.index].id
  }

  availability_zone = var.availability_zones_name[count.index]
}

resource "openstack_networking_floatingip_v2" "floating-ip" {
  pool    = "Ext-Net"
  region  = var.region_name
}

resource "openstack_networking_floatingip_associate_v2" "floating-ip-association" {
  region      = var.region_name
  floating_ip = openstack_networking_floatingip_v2.floating-ip.address
  port_id     = openstack_networking_port_v2.port[0].id

  depends_on = [ovh_cloud_project_gateway.gateway]
}

output "instance_1_public_ip" {
  value = openstack_networking_floatingip_v2.floating-ip.address
}

output "instance_1_private_ip" {
  value = openstack_networking_port_v2.port[0].all_fixed_ips[0]
}

output "instance_2_private_ip" {
  value = openstack_networking_port_v2.port[1].all_fixed_ips[0]
}

output "instance_3_private_ip" {
  value = openstack_networking_port_v2.port[2].all_fixed_ips[0]
}