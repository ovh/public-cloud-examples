output "serviceName" {
 value = var.serviceName
}

output "dbId" {
 value = ovh_cloud_project_database.mongodb.id
}

output "dbUserPassword" {
 value = ovh_cloud_project_database_mongodb_user.mongouser.password
 sensitive = true
}
