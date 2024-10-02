terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "0.37.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
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
  access_key  = "${ovh_cloud_project_user_s3_credential.s3_admin_cred.access_key_id}"
  secret_key  = "${ovh_cloud_project_user_s3_credential.s3_admin_cred.secret_access_key}"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation = true
  endpoints {
    s3 = "https://s3.${var.ovh_s3_region_name}.io.cloud.ovh.net"
  }
}