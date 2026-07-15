terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }

    kubectl = {
      source = "alekc/kubectl"
      version = "2.1.6"
    }

    ovh = {
      source = "ovh/ovh"
    }
  }
}

provider "helm" {
  kubernetes = {
    host                   = data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].host
    client_certificate     = base64decode(data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].client_certificate)
    client_key             = base64decode(data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].client_key)
    cluster_ca_certificate = base64decode(data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].host
  client_certificate     = base64decode(data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].client_certificate)
  client_key             = base64decode(data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].client_key)
  cluster_ca_certificate = base64decode(data.ovh_cloud_project_kube.mks_cluster.kubeconfig_attributes[0].cluster_ca_certificate)
  load_config_file       = false
}
