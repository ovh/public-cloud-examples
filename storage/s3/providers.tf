terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.25.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    region      = var.region
    access_key  = ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id
    secret_key  = ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key

    #OVH implementation has no STS service
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    # the gra region is unknown to AWS hence skipping is needed.
    skip_region_validation = true
    endpoints {
        s3 = var.s3_endpoint
    }
}

