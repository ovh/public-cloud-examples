terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.12.0"
    }
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.0"
    }
  }

  encryption {
    key_provider "pbkdf2" "my_passphrase" {
      passphrase = var.tofu_state_passphrase
    }
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.my_passphrase
    }
    state {
      method = method.aes_gcm.default
    }
  }

  required_version = ">= 1.11.4"
}

resource "time_static" "deployment" {}

locals {
  name_suffix = formatdate("DDMMYYhhmm", time_static.deployment.rfc3339)
}

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

provider "openstack" {
  alias       = "hub"

  auth_url    = "https://auth.cloud.ovh.net/v3/"
  domain_name = "default"
  tenant_id   = ovh_cloud_project.hub.project_id
  user_name   = ovh_cloud_project_user.hub_user.username
  password    = ovh_cloud_project_user.hub_user.password
  region      = var.compute_region
}

########################################################################################
# Hub OPNsense REST API credentials (key + bcrypt hash for config.xml)
########################################################################################

resource "random_string" "hub_api_key" {
  length  = 60
  special = false
  upper   = false
}

resource "random_password" "hub_api_secret" {
  length  = 60
  special = false
  upper   = false
}
