output "db_id" {
  description = "Db Id"
  value       = ovh_cloud_project_database.mongodb.id
}

output "db_user_password" {
  description = "Db User Password"
  value       = ovh_cloud_project_database_mongodb_user.mongouser.password
  sensitive   = true
}
