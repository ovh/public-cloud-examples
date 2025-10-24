output "s3_bucket" {
  value = "${ovh_cloud_project_storage.s3_bucket.name}"
}

output "access_key_id" {
    value = ovh_cloud_project_user_s3_credential.s3_user_cred.access_key_id
}

output "secret_access_key" {
    value = ovh_cloud_project_user_s3_credential.s3_user_cred.secret_access_key
    sensitive = true
}