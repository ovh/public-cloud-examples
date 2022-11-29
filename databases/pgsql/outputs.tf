output "serviceName" {
 value = var.serviceName
}

output "dbId" {
 value = ovh_cloud_project_database.pgsqldb.id
}

output "dbUserPassword" {
 value = ovh_cloud_project_database_postgresql_user.pgsqluser.password
 sensitive = true
}
