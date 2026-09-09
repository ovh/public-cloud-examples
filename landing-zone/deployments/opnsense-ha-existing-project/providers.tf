terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
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

########################################################################################
# OpenStack authentication — plain OpenStack credentials, no OVH API token.
# Source the openrc.sh of an OpenStack user with the "administrator" role on the project
# (OS_AUTH_URL, OS_PROJECT_ID, OS_USERNAME, OS_PASSWORD, OS_USER_DOMAIN_NAME=Default),
# or use a clouds.yaml + OS_CLOUD. Only the region is set here.
########################################################################################

provider "openstack" {
  region = var.region
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
