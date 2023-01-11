# Region

variable "region" {
  description = "Region"
  type        = string
}

# Database Engine

variable "db_engine" {
  description = "Db Engine parameters"
  type = object({
    region          = string
    pv_network_name = string
    subnet_name     = string
    description     = string
    engine          = string
    version         = string
    plan            = string
    flavor          = string
    allowed_ip      = list(string)
  })
}

# Database User

variable "user" {
  description = "Db User"
  type = object({
    name           = string
    group          = string
    password_reset = string
  })
}

# Database

variable "namespace" {
  description = "M3DB Namespace parameters"
  type = object({
    name                      = string
    resolution                = string
    retention_period_duration = string
  })
}
