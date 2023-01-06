terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
      version = "0.25.0"
    }
  }
}

provider "ovh" {
  endpoint           = var.ovh.endpoint
  application_key    = var.ovh.application_key
  application_secret = var.ovh.application_secret
  consumer_key       = var.ovh.consumer_key
}