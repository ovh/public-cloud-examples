variable "kubernetes" {
  description = "Kubernetes cluster definition"
  type        = map(any)
  default = {
    region = ""
  }
}

variable "resource_prefix" {
  type    = string
  default = "tf-public-cloud-examples-workpress-on-mks-with-mysql-"
}

variable "node_pool_flavor_name" {
  type    = string
  default = "b2-7"
}
