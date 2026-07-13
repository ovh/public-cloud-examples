terraform {
    backend "s3" {
      bucket = "terraform-state-3az" # the name of YOUR bucket
      key    = "my-app.tfstate" # the name of the state of your app
      region = "eu-west-par" # the region of the bucket
      endpoints = {
        s3 = "https://s3.eu-west-par.io.cloud.ovh.net/" # the endpoint
      }
      skip_credentials_validation = true
      skip_region_validation      = true
      skip_requesting_account_id  = true
      skip_s3_checksum            = true

      use_lockfile = true  # activation of the S3 native state locking feature
    }
}
