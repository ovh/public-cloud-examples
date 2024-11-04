resource "ovh_cloud_project_user" "s3_admin_user" {
  description	= "${var.ovh_s3_bucket_name} user"
  role_name	= "objectstore_operator"
}

resource "ovh_cloud_project_user_s3_credential" "s3_admin_cred"{
  user_id	= ovh_cloud_project_user.s3_admin_user.id
}

resource "random_string" "bucket_name_suffix" {
  length  = 16
  special = false
  lower   = true
  upper   = false
}

resource "aws_s3_bucket" "bucket"{
  bucket	= "${var.ovh_s3_bucket_name}-${random_string.bucket_name_suffix.result}"

  force_destroy = true
}