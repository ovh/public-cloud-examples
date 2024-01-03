terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
    }
    helm = {
      version = ">= 1.0"
      source = "hashicorp/helm"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

provider "ovh" {
}

provider "helm" {
  kubernetes {
    config_path = "kubeconfig_file"
    config_context = "kubernetes-admin@wordpress_kube_cluster"
  }
}

provider "openstack" {
  user_name   = var.openstack.user_name
  tenant_name = var.openstack.tenant_name
  password    = var.openstack.password
  auth_url    = var.openstack.auth_url
  region      = var.openstack.region
}