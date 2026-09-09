########################################################################################
#   SSH Keypair for Instances
########################################################################################

resource "openstack_compute_keypair_v2" "fw_keypair" {
  name       = "opnsense-keypair-ha"
  public_key = var.ssh_public_key_path != null ? trimspace(file(var.ssh_public_key_path)) : null
}

########################################################################################
#   OPNsense cloud-ready image (see docs/04-image-opnsense-cloud-ready.md)
########################################################################################

locals {
  image_source_url = coalesce(
    var.image_source_url,
    "https://opnsense.s3.eu-west-par.io.cloud.ovh.net/releases-cloudready/OPNsense-${var.opnsense_version}-cloudready.qcow2",
  )
}

resource "openstack_images_image_v2" "fw_image" {
  name             = "OPNsense ${var.opnsense_version} Cloud-Ready"
  image_source_url = local.image_source_url
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
