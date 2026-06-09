terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.12.0"
    }
  }
}
