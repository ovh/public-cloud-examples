variable "kubernetes" {
  description = "Kubernetes cluster definition"
  type        = map(any)
  default = {
    region = ""
  }
}
