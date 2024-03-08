output "kubeconfig_file" {
  value     = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  sensitive = true
}

output "nodepool_nodes" {
  value = data.ovh_cloud_project_kube_nodepool_nodes.nodes
}

output "network" {
  value = openstack_networking_network_v2.network
}
output "subnet" {
  value = openstack_networking_subnet_v2.subnet
}