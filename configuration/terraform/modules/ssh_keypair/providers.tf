terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.49.0"
    }
    local = {
      version = "~> 2.2.3"
    }
  }
  required_version = "~> 1.5.0"
}
