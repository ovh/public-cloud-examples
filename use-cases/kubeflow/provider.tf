terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.77.0"
    }
  }
}

provider "aws" {
  region      = "${var.ovh_s3_region_name}"

  access_key = module.s3_user.access_key_id
  secret_key = module.s3_user.secret_access_key

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation = true
  endpoints {
    s3 = "https://s3.${var.ovh_s3_region_name}.perf.cloud.ovh.net"
  }
}