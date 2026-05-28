########################################################################################
#     Hub | OpenStack Admin
########################################################################################

resource "ovh_cloud_project_user" "hub_user" {
  service_name = ovh_cloud_project.hub.project_id
  description  = "OVHLZ OpenStack User for hub project"
  role_names = [
    "compute_operator",
    "network_operator",
    "network_security_operator",
    "image_operator",
    "volume_operator",
    "key-manager_operator"
  ]
}

resource "ovh_cloud_project_user" "hub_compute_user" {
  service_name = ovh_cloud_project.hub.project_id
  description  = "OVHLZ compute-only user for hub project"
  role_names   = ["compute_operator"]
}

########################################################################################
#     Spoke QA | OpenStack Admin
########################################################################################

resource "ovh_cloud_project_user" "spoke_qa_user" {
  service_name = ovh_cloud_project.spoke_qa.project_id
  description  = "OVHLZ OpenStack User for spoke QA project"
  role_names = [
    "compute_operator",
    "network_operator",
    "network_security_operator",
    "image_operator",
    "volume_operator",
    "key-manager_operator"
  ]
}

resource "ovh_cloud_project_user" "spoke_qa_compute_user" {
  service_name = ovh_cloud_project.spoke_qa.project_id
  description  = "OVHLZ compute-only user for spoke QA project"
  role_names   = ["compute_operator"]
}

