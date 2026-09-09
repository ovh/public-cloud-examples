########################################################################################
#   Identities of the bubble — the "big admin" model
#     iac   : deploys the platform (this template)            — kept by the platform team
#     team  : compute only — boots instances, picks the SGs   — handed to the workload team
#     audit : read only — tools/audit-exposure.sh              — handed to security
########################################################################################
locals {
  iac_roles = ["compute_operator", "network_operator", "network_security_operator", "image_operator", "volume_operator"]
}

resource "ovh_cloud_project_user" "spoke_iac" {
  service_name = ovh_cloud_project.spoke.project_id
  description  = "OVHLZ IaC user for ${var.spoke_name}"
  role_names   = local.iac_roles
}

resource "ovh_cloud_project_user" "spoke_team" {
  service_name = ovh_cloud_project.spoke.project_id
  description  = "OVHLZ team user for ${var.spoke_name} (compute only)"
  role_names   = ["compute_operator"]
}

resource "ovh_cloud_project_user" "spoke_audit" {
  service_name = ovh_cloud_project.spoke.project_id
  description  = "OVHLZ audit user for ${var.spoke_name} (read only)"
  role_names   = ["infrastructure_supervisor"]
}
