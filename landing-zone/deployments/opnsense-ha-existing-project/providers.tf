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

provider "ovh" {
  endpoint           = var.ovh_endpoint
  application_key    = var.ovh_application_key
  application_secret = var.ovh_application_secret
  consumer_key       = var.ovh_consumer_key
}

provider "openstack" {
  auth_url    = "https://auth.cloud.ovh.net/v3/"
  domain_name = "default"
  tenant_id   = var.project_id
  user_name   = ovh_cloud_project_user.opnsense.username
  password    = ovh_cloud_project_user.opnsense.password
  region      = var.region
}

########################################################################################
# OPNsense REST API credentials — generated once, stored in state
########################################################################################

resource "random_string" "api_key" {
  length  = 60
  special = false
  upper   = false
}

resource "random_password" "api_secret" {
  length  = 60
  special = false
  upper   = false
}
