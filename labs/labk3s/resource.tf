resource "openstack_compute_instance_v2" "inst_" {
  for_each  = toset(var.name_list)
  name      = each.key
  image_id  = var.image_id
  flavor_id = var.flavor_id
  key_pair  = var.keypair_admin

  network {
    name = "Ext-Net"
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i ${self.network[0].fixed_ip_v4}, --private-key /home/gitpod/.ssh/id_rsa k3s.yml"
  }
}
