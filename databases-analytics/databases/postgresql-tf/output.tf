output "db_uri" {
  value = ovh_cloud_project_database.service_pg.endpoints.0.uri
}

output "user_name" {
  value = ovh_cloud_project_database_postgresql_user.user.name
}

output "user_password" {
  value     = ovh_cloud_project_database_postgresql_user.user.password
  sensitive = true
}