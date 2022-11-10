resource "openstack_compute_instance_v2" "inst_" {
  for_each        = toset(var.nameList)
  name            = "${each.key}"
  image_id        = var.imageId
  flavor_id       = var.flavorId
  key_pair        = "keypairAdmin"

  network {
    name = "Ext-Net"
  }
  
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i ${self.network[0].fixed_ip_v4}, --private-key /home/gitpod/.ssh/id_rsa k3s.yml"
  }
}

