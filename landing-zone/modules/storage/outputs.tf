####################################
#            S3 Buckets            #
####################################

output "bucket_name" {
  description = "OVH Landing Zone logs bucket"
  value       = ovh_cloud_project_storage.source.name
}

output "backup_bucket_name" {
  description = "OVH Landing Zone log replication bucket"
  value       = ovh_cloud_project_storage.backup.name
}