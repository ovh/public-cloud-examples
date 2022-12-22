variable service_name {
  type        = string
  default     = ""
}

variable ovh {
  type    = map
  default = {
    endpoint           = ""
    application_key    = ""
    application_secret = ""
    consumer_key       = ""
  }
}

variable database { 
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
  type    = map
  default ={
    project_id = ""
    region     = ""
  }
}

variable access {
  type    = map
  default = {
    ip = ""
  } 
}

variable openstack {
  type   = map
  default = {
    user_name   = ""
    tenant_name = ""
    password    = ""
    auth_url    = ""
    region      = ""
  } 
}