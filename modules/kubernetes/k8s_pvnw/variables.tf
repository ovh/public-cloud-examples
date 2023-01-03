# Region

variable "region" {
  description = "Region"
  type        = string
}

# Managed Kubernetes Cluster

variable "kube" {
  description = "Managed Kubernetes Cluster parameters"
  type = object({
    name            = string
    pv_network_name = string
    gateway_ip      = string
  })
}

variable "pool" {
  description = "Node Pool parameters"
  type = object({
    name          = string
    flavor        = string
    desired_nodes = string
    max_nodes     = string
    min_nodes     = string
  })
}
