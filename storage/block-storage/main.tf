resource "openstack_blockstorage_volume_v3" "bs_volume" {
  region = var.region
  name   = var.bs_name
  size   = var.bs_size
}
