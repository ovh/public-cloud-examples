output "db_id" {
  description = "Db Id"
  value       = ovh_cloud_project_database.mysql_engine.id
}

output "db_name" {
  description = "Db Name"
  value       = ovh_cloud_project_database_database.database.name
}

output "db_host" {
  description = "Db Host"
  value       = ovh_cloud_project_database.mysql_engine.endpoints.0.domain
}

output "db_port" {
  description = "Db Port"
  value       = ovh_cloud_project_database.mysql_engine.endpoints.0.port
}

output "user_name" {
  description = "Db User Name"
  value       = ovh_cloud_project_database_user.mysqluser.name
}

output "user_password" {
  description = "Db User Password"
  value       = ovh_cloud_project_database_user.mysqluser.password
  sensitive   = true
}
