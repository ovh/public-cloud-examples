variable "pg_type" {
  type = map(string)
  default = {
    region     = "GRA"
    plan       = "essential"
    flavor     = "db1-4"
    version    = "15"
  }
}

variable local_authorised_ip {
  type        = string
}