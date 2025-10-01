resource "ovh_cloud_project_rancher" "rancher" {
  project_id = var.service_name
  target_spec = {
    name = "MyRancherTF"
    plan = "STANDARD"
  }
}