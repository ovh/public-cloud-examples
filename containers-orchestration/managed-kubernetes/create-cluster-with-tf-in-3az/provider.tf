terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
    }
  }
}

provider "ovh" {
  # nothing defined here, Terraform will retrieve provider information in OVH_* environment variables
}