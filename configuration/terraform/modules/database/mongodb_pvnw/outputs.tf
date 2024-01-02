output "db_id" {
  description = "DB Id"
  value       = ovh_cloud_project_database.mongodb.id
}

output "db_user_password" {
  description = "DB User Password"
  value       = ovh_cloud_project_database_mongodb_user.mongouser.password
  sensitive   = true
}

output "db_connection_string" {
  description = "DB Connection String"
  value       = ovh_cloud_project_database.mongodb.endpoints.0.uri
}

output "db_service_connection_string" {
  description = "DB Connection String"
  value       = ovh_cloud_project_database.mongodb.endpoints.1.uri
}
