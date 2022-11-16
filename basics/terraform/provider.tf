terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
  }
}
