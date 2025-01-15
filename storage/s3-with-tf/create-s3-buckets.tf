# Create the bucket, the force_destroy argument will destroy the bucket even if it contains objects
resource "aws_s3_bucket" "my-bucket-s3" {
  force_destroy = true
  bucket = "bucket-name" # the name must be unique within OVHcloud
}