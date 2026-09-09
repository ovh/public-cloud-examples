output "slot" { value = var.slot }
output "supernet" { value = local.supernet }
output "transit_ip" { value = local.transit_ip }
output "router_id" { value = openstack_networking_router_v2.spoke.id }
output "lans" {
  description = "Spoke LANs: name => { cidr, vlan_id, network_id, subnet_id }"
  value = { for k, v in local.lans : k => {
    cidr       = v.cidr, vlan_id = v.vlan_id
    network_id = openstack_networking_network_v2.lan[k].id
    subnet_id  = openstack_networking_subnet_v2.lan[k].id
  } }
}
output "secgroup_base_id" { value = openstack_networking_secgroup_v2.base.id }
output "secgroup_intra_id" { value = openstack_networking_secgroup_v2.intra.id }
