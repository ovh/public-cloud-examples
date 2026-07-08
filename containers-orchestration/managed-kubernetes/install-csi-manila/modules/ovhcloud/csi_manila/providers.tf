terraform {
  required_providers {
    helm = {
      source = "opentofu/helm"
    }

    ovh = {
      source = "ovh/ovh"
    }

    kubectl = {
      source = "alekc/kubectl"
    }
  }
}
