########################################################################################
#     OpenStack Admin User
########################################################################################

resource "ovh_cloud_project_user" "spoke_user" {
  service_name = ovh_cloud_project.spoke.project_id
  description  = "OVHLZ OpenStack User for ${var.spoke_name}"
  role_names = [
    "compute_operator",
    "network_operator",
    "network_security_operator",
    "image_operator",
    "volume_operator",
    "key-manager_operator"
  ]
}
