output "m3db_user_password" {
  value     = ovh_cloud_project_database_m3db_user.user.password
  sensitive = true
}
