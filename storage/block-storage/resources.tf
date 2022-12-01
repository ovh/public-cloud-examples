resource "openstack_blockstorage_volume_v3" "bsVolume" {
  region = var.region
  name   = var.bsName
  size   = var.bsSize
}
