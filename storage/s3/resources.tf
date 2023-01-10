
########################################################################################
#     User / Credential
########################################################################################
resource "ovh_cloud_project_user" "s3_admin_user" {
  service_name = var.serviceName
  description = "User created by terraform that is used to manage S3 bucket"
  role_name = "objectstore_operator"
} 
resource "ovh_cloud_project_user_s3_credential" "s3_admin_cred"{
  service_name = var.serviceName
  user_id = ovh_cloud_project_user.s3_admin_user.id
}


########################################################################################
#     Bucket
########################################################################################
resource "aws_s3_bucket" "b"{
  bucket = "${var.bucket_name_prefix}-${ovh_cloud_project_user.s3_admin_user.id}"
}


resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}