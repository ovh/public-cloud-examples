resource "openstack_compute_keypair_v2" "myMainKeypair" {
  region = var.keypair.keypairMainRegion
  name   = var.keypair.keypairName
}

resource "local_file" "ssh_private_key" {
  content         = openstack_compute_keypair_v2.myMainKeypair.private_key
  filename        = "${path.module}/${var.keypair.keypairName}_rsa"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content         = openstack_compute_keypair_v2.myMainKeypair.public_key
  filename        = "${path.module}/${var.keypair.keypairName}_rsa.pub"
  file_permission = "0644"
}

resource "openstack_compute_keypair_v2" "myOtherKeypair" {
  //  depends_on = [openstack_compute_keypair_v2.myMainKeypair, local_file.ssh_public_key, local_file.ssh_private_key]
  for_each = toset(var.keypair.keypairToReproduceRegions)

  region     = each.key
  name       = var.keypair.keypairName
  public_key = local_file.ssh_public_key.content
}
