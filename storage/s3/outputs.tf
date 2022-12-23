output "serviceName" {
  value = var.serviceName
}

output "bucketName"{
  value = aws_s3_bucket.b.id
}