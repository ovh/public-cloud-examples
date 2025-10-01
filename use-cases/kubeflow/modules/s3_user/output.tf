output "access_key_id" {
    value = ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id
}

output "secret_access_key" {
    value = ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key
}