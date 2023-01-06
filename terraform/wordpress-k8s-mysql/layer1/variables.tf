variable service_name {
  description = "Public cloud project service name"
  type        = string
  default     = ""
}

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

variable kubernetes {
  description = "Kubernetes cluster definition"
  type    = map
  default ={
    project_id = ""
    region     = ""
  }
}