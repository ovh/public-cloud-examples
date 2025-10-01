terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 1.1.0"

    }
    helm = {
      version = ">= 1.0"
      source  = "hashicorp/helm"
    }
  }
}

provider "ovh" {
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig.yml"
  }
}