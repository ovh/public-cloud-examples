# Module: Storage

This module provisions a multi-region storage solution using OVHcloud Object Storage (S3). It establishes a primary-secondary bucket topology designed for automated data redundancy, cost-optimized retention, and strict regulatory adherence.

Core Features:

- Cross-Region Replication: Automated synchronization from the primary bucket (Standard storage class) to the backup bucket in a separate region (Infrequent Access class) for disaster recovery.
- Lifecycle Management: Advanced transition rule that automatically moves logs to infrequent access and enforces an expiration policy for temporary data.
- Governance & Compliance: Includes an optional Object Lock (Compliance Mode) for the backup bucket. When enabled, this enforces a 90-day retention period to meet compliance and governance requirements by preventing premature deletion.

## Providers

| Name | Version |
| ---- | ------- |
| [ovh](https://search.opentofu.org/provider/ovh/ovh/latest) | ~> 2.12.0 |
| [random](https://search.opentofu.org/provider/hashicorp/random/latest) | ~> 3.7.2 |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| [project_id](./variables.tf) | Public cloud project ID of the object storage | `string` | - | yes |
| [ovh_S3_user_id](./variables.tf) | User ID of the object storage user | `string` | - | yes |
| [bucket_prefix](./variables.tf) | The prefix for the S3 bucket name | `string` | - | yes |
| [region](./variables.tf) | The region for the S3 bucket | `string` | - | yes |
| [backup_region](./variables.tf) | The region for the backup S3 bucket | `string` | - | yes |
| [compliance_mode](./variables.tf) | Enable S3 object locking | `bool` | `false` | no |

## Resources

| Name | Type |
| ---- | ---- |
| [ovh_cloud_project_storage.backup](https://search.opentofu.org/provider/ovh/ovh/latest/docs/resources/cloud_project_storage) | resource |
| [ovh_cloud_project_storage.source](https://search.opentofu.org/provider/ovh/ovh/latest/docs/resources/cloud_project_storage) | resource |
| [ovh_cloud_project_user_s3_policy.bucket_policy](https://search.opentofu.org/provider/ovh/ovh/latest/docs/resources/cloud_project_user_s3_policy) | resource |
| [ovh_cloud_project_storage_object_bucket_lifecycle_configuration.lifecycle](https://search.opentofu.org/provider/ovh/ovh/latest/docs/resources/cloud_project_storage_object_bucket_lifecycle_configuration) | resource |
| [random_string.bucket_suffix](https://search.opentofu.org/provider/hashicorp/random/latest/docs/resources/string) | resource |

## Outputs

| Name | Description |
| ---- | ----------- |
| [bucket_name](./outputs.tf) | OVH Landing Zone logs bucket |
| [backup_bucket_name](./outputs.tf) | OVH Landing Zone log replication bucket |
