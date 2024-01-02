terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.29.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.49.0"
    }
  }
  required_version = "~> 1.3.6"
}
