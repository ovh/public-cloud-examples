terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 1.0.0"
    }
    helm = {
      version = ">= 1.0"
      source  = "hashicorp/helm"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig_file.filename
  }
}

provider "kubernetes" {
  config_path = local_file.kubeconfig_file.filename
}
