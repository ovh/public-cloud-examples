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

variable kubernetes {
  type    = map
  default ={
    project_id = ""
    region     = ""
  }
}