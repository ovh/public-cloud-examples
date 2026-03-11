resource "openstack_blockstorage_volume_v3" "volume" {
  region          = var.region_name
  name        = "${var.demo_name}-data"
  size        = var.volume_size
  volume_type = "classic-multiattach"
}

resource "openstack_compute_volume_attach_v2" "volume_attach" {
  count = 3

  region      = var.region_name
  instance_id = openstack_compute_instance_v2.instance[count.index].id
  volume_id   = openstack_blockstorage_volume_v3.volume.id
  multiattach = true
}