resource "ovh_cloud_project_user" "s3_admin_user" {
  description	= "${var.ovh_s3_bucket_name} user"
  role_name	= "objectstore_operator"
}

resource "ovh_cloud_project_user_s3_credential" "s3_admin_cred"{
  user_id	= ovh_cloud_project_user.s3_admin_user.id
}