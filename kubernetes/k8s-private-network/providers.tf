terraform {
  required_providers {
    ovh = {
      source = "ovh/ovh"
      version = "~> 0.23.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
