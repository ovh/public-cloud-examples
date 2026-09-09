# The project is attached to the hub vRack by the order itself; leave the platform a moment
# before creating vRack networks in it.
resource "time_sleep" "wait_spoke_vrack" {
  depends_on      = [ovh_cloud_project.spoke]
  create_duration = "60s"
}
