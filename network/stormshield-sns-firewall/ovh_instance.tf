resource "openstack_compute_servergroup_v2" "stormshield" {
  name     = "${var.ovh_os_instance_name}-stormshield"
  region   = var.ovh_os_instance_region
  policies = ["anti-affinity"]
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "${var.ovh_os_instance_name}-keypair"
  public_key = var.ssh_public_key
}

resource "openstack_compute_instance_v2" "instance" {
  count = 2

  name            = "${var.ovh_os_instance_name}-${count.index + 1}"
  region          = var.ovh_os_instance_region
  image_name      = var.ovh_os_instance_image_name
  flavor_name     = var.ovh_os_instance_flavor_name
  key_pair        = openstack_compute_keypair_v2.keypair.name

  scheduler_hints {
    group = openstack_compute_servergroup_v2.stormshield.id
  }

  connection {
    type        = "ssh"
    user        = "admin"
    password    = var.ovh_os_instance_password
    host        = var.ovh_os_instance_wan_ip[count.index]
  }

  provisioner "file" {
    source      = "./stormshield-maj/"
    destination = "/tmp"
  }

  user_data = base64encode(templatefile("templates/stormshield-config.tpl",
    {
      SERIAL_NUMBER=var.stormshield_serial_number[count.index]
      PASSWORD=var.ovh_os_instance_password
      WAN_IP=var.ovh_os_instance_wan_ip[count.index]
      WAN_MASK=var.ovh_os_instance_wan_mask
      WAN_GW=var.ovh_os_instance_wan_gw
      LAN_IP=cidrhost(openstack_networking_subnet_v2.private-subnet-workload.cidr, 1)
      LAN_MASK=cidrnetmask(openstack_networking_subnet_v2.private-subnet-workload.cidr)
      HA_IP=cidrhost(openstack_networking_subnet_v2.private-subnet-ha.cidr, count.index + 3)
      HA_MASK=cidrnetmask(openstack_networking_subnet_v2.private-subnet-ha.cidr)
      HA_ID=count.index + 1
      HA_PRIMARY_IP=cidrhost(openstack_networking_subnet_v2.private-subnet-ha.cidr, count.index + 2)
      ADMIN_CLIENT_IP=var.admin_client_ip
    }
  ))

  network {
    name = openstack_networking_network_v2.private-net-ext.name
  }

  network {
    name = openstack_networking_network_v2.private-net-workload.name
  }

  network {
    name = openstack_networking_network_v2.private-net-ha.name
  }
}