terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "~> 2.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7.2"
    }
  }
}
