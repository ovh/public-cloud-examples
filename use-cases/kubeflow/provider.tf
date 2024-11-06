terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "1.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "helm" {
  kubernetes {
    host                    = ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].host
    client_certificate      = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].client_certificate)
    client_key              = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].client_key)
    cluster_ca_certificate  = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                    = ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].host
  client_certificate      = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].client_certificate)
  client_key              = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].client_key)
  cluster_ca_certificate  = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
}

provider "kubectl" {
  host                    = ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].host
  client_certificate      = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].client_certificate)
  client_key              = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].client_key)
  cluster_ca_certificate  = base64decode(ovh_cloud_project_kube.ovh_kube_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
}

provider "aws" {
  region      = "${var.ovh_s3_region_name}"
  access_key  = "${var.ovh_s3_access_key}"
  secret_key  = "${var.ovh_s3_secret_key}"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation = true
  endpoints {
    s3 = "https://s3.${var.ovh_s3_region_name}.perf.cloud.ovh.net"
  }
}