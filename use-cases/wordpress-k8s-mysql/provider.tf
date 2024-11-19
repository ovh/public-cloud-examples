terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 1.0.0"
    }
    helm = {
      version = ">= 2.0.0"
      source  = "hashicorp/helm"
    }

  }
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig_file.filename
  }
}

