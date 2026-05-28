########################################################################################
#   SSH Keypair for Instances
########################################################################################

resource "openstack_compute_keypair_v2" "fw_keypair" {
  name       = "opnsense-keypair-ha"
  public_key = var.ssh_public_key_path != null ? trimspace(file(var.ssh_public_key_path)) : null
}

resource "ovh_cloud_project_ssh_key" "fw_ssh_key" {
  service_name = var.os_tenant_id
  public_key   = openstack_compute_keypair_v2.fw_keypair.public_key
  name         = openstack_compute_keypair_v2.fw_keypair.name
  region       = var.os_region
}

########################################################################################
#   Upload OPNsense VM Image to OpenStack
########################################################################################

resource "openstack_images_image_v2" "fw_image" {
  name             = "OPNsense Cloud-Ready"
  image_source_url = "https://opnsense.s3.eu-west-par.io.cloud.ovh.net/releases-cloudready/OPNsense-26.1-cloudready.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
}

########################################################################################
#   HA Cluster Server Group
########################################################################################

resource "openstack_compute_servergroup_v2" "fw_servergroup" {
  name     = "opnsense-sg-ha"
  policies = ["anti-affinity"]
}
