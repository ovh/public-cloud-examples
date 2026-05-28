########################################################################################
# IAM Policies — Spoke constellation-dev
#
# Prerequisite: the identities below must already exist at the OVHcloud account level
# before this tofu apply. Create them in the Manager: Identity and access → Local users
# and → Service accounts.
########################################################################################

# IAM policy — FleetOS team, compute-only on constellation-dev
resource "ovh_iam_policy" "fleeetos_constellation_dev_compute" {
  name        = "orbital-edge-fleeetos-constellation-dev"
  description = "FleetOS team — compute-only on constellation-dev"
  identities = [
    "urn:v1:eu:identity:user:${data.ovh_me.myaccount.nichandle}/camille.dubois",
    # Add the other FleetOS team members here
    # Format: "urn:v1:eu:identity:user:${data.ovh_me.myaccount.nichandle}/<login>"
  ]
  resources = [
    "urn:v1:eu:resource:publicCloudProject:${ovh_cloud_project.spoke.project_id}",
  ]
  allow = ["publicCloudProject:openstack:compute:*"]
}

# IAM policy — constellation GitLab CI pipeline (service account)
resource "ovh_iam_policy" "ci_constellation_dev_compute" {
  name        = "orbital-edge-ci-constellation-dev"
  description = "GitLab CI pipeline — compute-only on constellation-dev"
  identities = [
    "urn:v1:eu:identity:credential:${data.ovh_me.myaccount.nichandle}/${var.iam_ci_service_account_login}",
  ]
  resources = [
    "urn:v1:eu:resource:publicCloudProject:${ovh_cloud_project.spoke.project_id}",
  ]
  allow = ["publicCloudProject:openstack:compute:*"]
}
