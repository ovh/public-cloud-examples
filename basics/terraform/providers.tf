terraform {
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.25.0"
    }
    # tflint-ignore: terraform_unused_required_providers
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.49.0"
    }
  }
  required_version = "~> 1.3.6"
}
