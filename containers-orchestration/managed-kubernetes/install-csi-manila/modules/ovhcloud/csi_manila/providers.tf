terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }

    ovh = {
      source = "ovh/ovh"
    }

    kubectl = {
      source = "alekc/kubectl"
    }
  }
}
