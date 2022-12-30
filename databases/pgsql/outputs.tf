output "service_name" {
  description = "Service Name"
  value       = var.service_name
}

output "db_id" {
  description = "Db Id"
  value       = ovh_cloud_project_database.pgsqldb.id
}

output "db_user_password" {
  description = "Db User Password"
  value       = ovh_cloud_project_database_postgresql_user.pgsqluser.password
  sensitive   = true
}
