data "ovh_cloud_project_loadbalancer_flavors" "flavors" {
  service_name = var.service_name
  region_name  = var.region
}

output "flavor_small" {
    value = element([for name in data.ovh_cloud_project_loadbalancer_flavors.flavors.flavors: name if "${name.name}" == "small"], 0).id
}