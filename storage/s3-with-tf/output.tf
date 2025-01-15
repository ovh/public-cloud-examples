# Output the Object Storage name after its creation

output "my-bucket-s3" {
  value = "${aws_s3_bucket.my-bucket-s3.id}"
}