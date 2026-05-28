####################################
#      Storage Configuration       #
####################################

variable "project_id" {
  description = "Public cloud project ID of the object storage"
  type        = string
}

variable "ovh_S3_user_id" {
  description = "User ID of the object storage user"
  type        = string
}

variable "bucket_prefix" {
  description = "The prefix for the S3 bucket name"
  type        = string
  validation {
    condition = length(var.bucket_prefix) <= 14
    error_message = "Bucket prefix must have length less than or equal to 14"
  }
}

variable "region" {
  description = "The region for the S3 bucket"
  type        = string
}

variable "backup_region" {
  description = "The region for the backup S3 bucket"
  type        = string
}

variable "compliance_mode" {
  description = "Enable S3 object locking"
  type        = bool
  default     = false
}