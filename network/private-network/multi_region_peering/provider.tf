########################################################################################
# This script requires the following variables to be defined for the OVH provider :
# OVH_ENDPOINT
# OVH_APPLICATION_KEY
# OVH_APPLICATION_SECRET
# OVH_CONSUMER_KEY
# The following is required specifically for this script:
# TF_VAR_OVH_PUBLIC_CLOUD_PROJECT_ID that shall be filled with your public cloud project id or it will be requested on script startup
########################################################################################





#######################################################################################
#     Providers
########################################################################################
# Define providers and set versions
terraform {
  required_version = ">= 0.14.0" # Takes into account Terraform versions from 0.14.0
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 2.1.0"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "~> 0.45.0"
    }
  }
}

# Configure the OpenStack expoprovider hosted by OVHcloud
provider "openstack" {
  auth_url         = "https://auth.cloud.ovh.net/v3/"
  domain_name      = "Default" # Domain name - Always at 'default' for OVHcloud
  user_domain_name = "Default"
  user_name        = ovh_cloud_project_user.user.username
  password         = ovh_cloud_project_user.user.password
  tenant_id        = var.ovh_public_cloud_project_id
}
provider "ovh" {

}
resource "ovh_cloud_project_user" "user" {
  service_name = var.ovh_public_cloud_project_id
  description  = "User created by terraform script"
  role_name    = "administrator"
}