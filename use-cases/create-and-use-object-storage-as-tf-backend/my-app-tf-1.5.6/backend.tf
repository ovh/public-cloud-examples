terraform {
    backend "s3" {
      bucket = "<my-bucket>"
      key    = "my-app-tf-1.5.6.tfstate"
      region = "gra"
      endpoint = "s3.gra.io.cloud.ovh.net"
      skip_credentials_validation = true
      skip_region_validation      = true
    }
}