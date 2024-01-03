variable "database" {
  description = "Wordpress website database parameters"
  type        = map(any)
  default = {
    region       = ""
    plan         = ""
    flavor       = ""
    version      = ""
  }
}
