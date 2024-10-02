resource "ovh_cloud_project_user" "s3_admin_user" {
  service_name	= "${var.ovh_os_project_id}"
  description	= "${var.ovh_s3_bucket_name} user"
  role_name	= "objectstore_operator"
}

resource "ovh_cloud_project_user_s3_credential" "s3_admin_cred"{
  service_name	= "${var.ovh_os_project_id}"
  user_id	= ovh_cloud_project_user.s3_admin_user.id
}

resource "aws_s3_bucket" "bucket"{
  bucket	= "${var.ovh_s3_bucket_name}-${var.ovh_os_project_id}"

  force_destroy = true
}