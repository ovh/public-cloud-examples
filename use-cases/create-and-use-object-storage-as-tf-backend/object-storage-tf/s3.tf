resource "random_string" "bucket_name_suffix" {
  length  = 16
  special = false
  lower   = true
  upper   = false
}

resource "ovh_cloud_project_storage" "s3_bucket" {
  service_name = var.service_name
  region_name = var.bucket_region
  name = "${var.bucket_name}-${random_string.bucket_name_suffix.result}" # the name must be unique within OVHcloud
}

resource "ovh_cloud_project_user" "s3_user" {
  description	= "${var.bucket_name}-${random_string.bucket_name_suffix.result}"
  role_name	= "objectstore_operator"
}

resource "ovh_cloud_project_user_s3_credential" "s3_user_cred" {
  user_id	= ovh_cloud_project_user.s3_user.id
}

resource "ovh_cloud_project_user_s3_policy" "s3_user_policy" {
  service_name = var.service_name
  user_id      = ovh_cloud_project_user.s3_user.id
  policy = jsonencode({
    "Statement": [{
      "Action": ["s3:*"],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${ovh_cloud_project_storage.s3_bucket.name}","arn:aws:s3:::${ovh_cloud_project_storage.s3_bucket.name}/*"],
      "Sid": "AdminContainer"
    }]
  })
}