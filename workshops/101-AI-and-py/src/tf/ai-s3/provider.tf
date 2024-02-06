terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    ovh = {
      source  = "ovh/ovh"
    }
  }
}

# Configure the OpenStack Provider
provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3"
  region      = "GRA"
}

# Configure the AWS Provider
provider "aws" {
  region     = "gra"
  
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"

  # OVH implementation has no STS service
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  # the gra region is unknown to AWS hence skipping is needed.
  skip_region_validation = true
  endpoints {
    s3 = "https://s3.gra.io.cloud.ovh.net"
  }
}