########################################################################################
#     Hub | OpenStack identities
########################################################################################
resource "ovh_cloud_project_user" "hub_user" {
  service_name = ovh_cloud_project.hub.project_id
  description  = "OVHLZ IaC user for the hub project"
  role_names = [
    "compute_operator",
    "network_operator",
    "network_security_operator",
    "image_operator",
    "volume_operator",
  ]
}

resource "ovh_cloud_project_user" "hub_compute_user" {
  service_name = ovh_cloud_project.hub.project_id
  description  = "OVHLZ compute-only user for the hub project"
  role_names   = ["compute_operator"]
}
