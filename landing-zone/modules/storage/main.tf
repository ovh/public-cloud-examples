########################################################################################
#   Bucket Suffix
########################################################################################

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  lower   = true
  upper   = false
}

########################################################################################
#   Source  Bucket + Replication Rule
########################################################################################

resource "ovh_cloud_project_storage" "source" {
  service_name = var.project_id
  region_name  = var.region
  name         = "${var.bucket_prefix}-${var.project_id}-${random_string.bucket_suffix.result}"

  versioning = {
    status = "enabled"
  }

  encryption = {
    sse_algorithm = "AES256"
  }

  replication = {
    rules = [
      {
        id                        = "logs_replication"
        priority                  = 1
        status                    = "enabled"
        delete_marker_replication = var.compliance_mode ? "disabled" : "enabled"
        destination = {
          name                           = ovh_cloud_project_storage.backup.name
          region                         = var.backup_region
          storage_class                  = "STANDARD_IA"
          remove_on_main_bucket_deletion = false
        }
        filter = {
          prefix = "logs/"
        }
      }
    ]
  }
}

########################################################################################
#   Backup  Bucket | Configurations: Encrytion, Versioning, Object Locking
########################################################################################

resource "ovh_cloud_project_storage" "backup" {
  service_name = var.project_id
  region_name  = var.backup_region
  name         = "${var.bucket_prefix}-${var.project_id}-${random_string.bucket_suffix.result}-backup"

  versioning = {
    status = "enabled"
  }

  encryption = {
    sse_algorithm = "AES256"
  }

  object_lock = {
    status = var.compliance_mode ? "enabled" : "disabled"
    rule = {
      mode   = "compliance"
      period = "P90D"
    }
  }
}

########################################################################################
#   S3 User Bucket Policy
########################################################################################

resource "ovh_cloud_project_user_s3_policy" "bucket_policy" {
  service_name = var.project_id
  user_id      = var.ovh_S3_user_id

  policy = jsonencode({
    "Statement" : [
      {
        "Action" : ["s3:*"],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::${ovh_cloud_project_storage.source.name}",
          "arn:aws:s3:::${ovh_cloud_project_storage.source.name}/*",
          "arn:aws:s3:::${ovh_cloud_project_storage.backup.name}",
          "arn:aws:s3:::${ovh_cloud_project_storage.backup.name}/*"

        ]
      }
    ]
  })
}

########################################################################################
#   Source  Bucket | Lifecycle Rules
########################################################################################

resource "ovh_cloud_project_storage_object_bucket_lifecycle_configuration" "lifecycle" {
  service_name   = ovh_cloud_project_storage.source.service_name
  region_name    = ovh_cloud_project_storage.source.region_name
  container_name = ovh_cloud_project_storage.source.name

  rules = [
    {
      id     = "log-files-transition"
      status = "enabled"
      filter = {
        prefix = "logs/"
      }
      transitions = [
        {
          days          = 60
          storage_class = "STANDARD_IA"
        }
      ]
      noncurrent_version_transitions = [
        {
          noncurrent_days = 30
          storage_class   = "STANDARD_IA"
        }
      ]
    },
    {
      id     = "temp-files-expiration"
      status = "enabled"
      filter = {
        prefix = "temp/"
      }
      expiration = {
        days = 14
      }
      noncurrent_version_expiration = {
        noncurrent_days = 7
      }
    }
  ]
}
