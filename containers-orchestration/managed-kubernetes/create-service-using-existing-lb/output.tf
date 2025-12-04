output "lb_id" {
  value = ovh_cloud_project_loadbalancer.lb.id
}

output "lb_floating_ip" {
  value = ovh_cloud_project_loadbalancer.lb.floating_ip.ip
}