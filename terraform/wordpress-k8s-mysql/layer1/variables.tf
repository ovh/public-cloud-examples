
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