terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
    }
  }
}

provider "ovh" {
  application_secret = var.ovh.application_secret
  consumer_key       = var.ovh.consumer_key
}