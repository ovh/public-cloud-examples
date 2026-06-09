########################################################################################
# IAM Policies — Spoke signalvault-dev
#
# Prerequisite: the identities below must already exist at the OVHcloud account level
# before this tofu apply. Create them in the Manager: Identity and access → Local users
# and → Service accounts.
########################################################################################

# IAM policy — SignalVault team, compute-only on signalvault-dev
resource "ovh_iam_policy" "signalvault_dev_compute" {
  name        = "orbital-edge-signalvault-dev"
  description = "SignalVault team — compute-only on signalvault-dev"
  identities = [
    "urn:v1:eu:identity:user:${data.ovh_me.myaccount.nichandle}/driss.el-fassi",
    # Add the other SignalVault team members here
    # Format: "urn:v1:eu:identity:user:${data.ovh_me.myaccount.nichandle}/<login>"
  ]
  resources = [
    "urn:v1:eu:resource:publicCloudProject:${ovh_cloud_project.spoke.project_id}",
  ]
  allow = ["publicCloudProject:openstack:compute:*"]
}

# IAM policy — signalvault GitLab CI pipeline (service account)
resource "ovh_iam_policy" "ci_signalvault_dev_compute" {
  name        = "orbital-edge-ci-signalvault-dev"
  description = "GitLab CI pipeline — compute-only on signalvault-dev"
  identities = [
    "urn:v1:eu:identity:credential:${data.ovh_me.myaccount.nichandle}/${var.iam_ci_service_account_login}",
  ]
  resources = [
    "urn:v1:eu:resource:publicCloudProject:${ovh_cloud_project.spoke.project_id}",
  ]
  allow = ["publicCloudProject:openstack:compute:*"]
}
