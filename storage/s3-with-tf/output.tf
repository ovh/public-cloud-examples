# Output the Object Storage name after its creation

output "my_s3_bucket_1az" {
  value = "${ovh_cloud_project_storage.my_s3_bucket_1az.name}"
}

output "my_s3_bucket_3az" {
  value = "${ovh_cloud_project_storage.my_s3_bucket_3az.name}"
}