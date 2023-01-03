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
    user_name       = string
    allowed_ip      = list(string)
  })
}

# Database

variable "db" {
  description = "Db parameters"
  type = object({
    name = string
  })
}
