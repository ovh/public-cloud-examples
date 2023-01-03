resource "openstack_compute_keypair_v2" "my_main_keypair" {
  region = var.keypair.main_region
  name   = var.keypair.name
}

resource "local_file" "ssh_private_key" {
  content         = openstack_compute_keypair_v2.my_main_keypair.private_key
  filename        = "${path.module}/${var.keypair.name}_rsa"
  file_permission = "0600"
}

resource "local_file" "ssh_public_key" {
  content         = openstack_compute_keypair_v2.my_main_keypair.public_key
  filename        = "${path.module}/${var.keypair.name}_rsa.pub"
  file_permission = "0600"
}

resource "openstack_compute_keypair_v2" "my_other_keypair" {
  #  depends_on = [openstack_compute_keypair_v2.my_main_keypair, local_file.ssh_public_key, local_file.ssh_private_key]
  for_each = toset(var.keypair.to_reproduce_regions)

  region     = each.key
  name       = var.keypair.name
  public_key = local_file.ssh_public_key.content
}
