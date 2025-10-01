output "db_id" {
  value = ovh_cloud_project_database.service_pg.id
}

output "db_uri" {
  value = ovh_cloud_project_database.service_pg.endpoints.0.uri
}

output "db_port" {
  value = ovh_cloud_project_database.service_pg.endpoints.0.port
}

output "db_domain" {
  value = ovh_cloud_project_database.service_pg.endpoints.0.domain
}

output "user_name" {
  value = ovh_cloud_project_database_postgresql_user.user.name
}

output "user_password" {
  value     = ovh_cloud_project_database_postgresql_user.user.password
  sensitive = true
}