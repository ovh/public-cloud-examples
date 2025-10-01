terraform {
  required_providers {
    ovh = {
      source  = "ovh/ovh"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

provider "ovh" {
}