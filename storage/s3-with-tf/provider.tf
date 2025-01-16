terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region     = "${var.region}"

  # OVH implementation has no STS service
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  # the gra region is unknown to AWS hence skipping is needed.
  skip_region_validation = true
  endpoints {
    s3 = "https://s3.${var.region}.io.cloud.ovh.net"
  }
}