# Create a bucket, in 1-AZ region 
resource "ovh_cloud_project_storage" "my_s3_bucket_1az" {
  service_name = var.service_name
  region_name = var.region_1AZ
  name = "bucket-name"  # the name must be unique within OVHcloud
}

# Create a bucket, in 3-AZ region 
resource "ovh_cloud_project_storage" "my_s3_bucket_3az" {
  service_name = var.service_name
  region_name = var.region_3AZ
  name = "bucket-name-3az"  # the name must be unique within OVHcloud
}