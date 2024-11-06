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