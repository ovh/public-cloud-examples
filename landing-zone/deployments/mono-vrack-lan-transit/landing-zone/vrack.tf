########################################################################################
#   vRack: delivered with the hub project, shared by every spoke (attached at order time).
#   Delivery lags the project by 2-3 minutes: wait before reading it.
########################################################################################
resource "time_sleep" "wait_hub_vrack" {
  depends_on      = [ovh_cloud_project.hub]
  create_duration = "240s"
}

data "ovh_cloud_project_vrack" "hub" {
  service_name = ovh_cloud_project.hub.project_id
  depends_on   = [time_sleep.wait_hub_vrack]
}
