output "ai-s3" {
  value = ["${aws_s3_bucket.ai-s3.*.id}"]
}