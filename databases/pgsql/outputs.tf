output "serviceName" {
  description = "Service Name"
  value       = var.serviceName
}

output "dbId" {
  description = "Db Id"
  value       = ovh_cloud_project_database.pgsqldb.id
}

output "dbUserPassword" {
  description = "Db User Password"
  value       = ovh_cloud_project_database_postgresql_user.pgsqluser.password
  sensitive   = true
}
