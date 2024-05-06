terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.43.1"

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