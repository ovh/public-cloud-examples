output "kubeconfig_file" {
  value     = ovh_cloud_project_kube.wordpress_kube_cluster.kubeconfig
  sensitive = true
}

output "nodepool_nodes" {
  value = data.ovh_cloud_project_kube_nodepool_nodes.nodes
}

output "network_uid" {
  value = tolist(ovh_cloud_project_network_private.private_network.regions_attributes)[0].openstackid
}
output "subnet" {
  value = ovh_cloud_project_network_private_subnet.subnet
}