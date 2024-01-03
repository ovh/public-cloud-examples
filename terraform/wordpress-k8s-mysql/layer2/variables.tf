
variable ovh {
  description = "OVHcloud provider parameters"
  type    = map
  default = {
    endpoint           = ""
    application_key    = ""
    application_secret = ""
    consumer_key       = ""
  }
}

variable database { 
  description = "Wordpress website database parameters"
  type     = map
  default = {
    project_id = ""
    region     = ""
    plan       = ""
    flavor     = ""
    version    = ""
  } 
}

variable kubernetes {
  description = "Kubernetes cluster definition"
  type    = map
  default ={
    project_id = ""
    region     = ""
  }
}

variable openstack {
  description = "Personnal Openstack connection informations"
  type   = map
  default = {
    user_name   = ""
    tenant_name = ""
    password    = ""
    auth_url    = ""
    region      = ""
  } 
}