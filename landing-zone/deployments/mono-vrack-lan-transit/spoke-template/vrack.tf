########################################################################################
#   vRack — attach to the existing shared vRack (no creation)
########################################################################################

resource "time_sleep" "wait_spoke_vrack" {
  depends_on      = [ovh_cloud_project.spoke]
  create_duration = "30s"
}
