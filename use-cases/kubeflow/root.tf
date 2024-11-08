module "s3_user" {
  source = "./modules/s3_user"
}

module "kubeflow" {
  source = "./modules/kubeflow"
  ovh_s3_access_key = module.s3_user.access_key_id
  ovh_s3_secret_key = module.s3_user.secret_access_key
  ovh_dns_domain = var.ovh_dns_domain
  ovh_api_dns_application_key = var.ovh_api_dns_application_key
  ovh_api_dns_consumer_key = var.ovh_api_dns_consumer_key
  ovh_api_dns_application_secret = var.ovh_api_dns_application_secret
}