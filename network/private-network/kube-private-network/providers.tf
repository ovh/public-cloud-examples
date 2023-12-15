terraform {
  required_providers {
    local = {
      version = "~> 2.2.3"
    }
    helm = {
      version = ">= 1.0"
      source  = "hashicorp/helm"
    }
  }
  required_version = "~> 1.5.0"
}

provider "helm" {
  kubernetes {
    config_path    = "kubeconfig_file"
    config_context = "kubernetes-admin@mykubernetesCluster"
  }
}
