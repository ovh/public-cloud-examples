# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "network" {
  description = "Private Network Parameters"
  type = object({
    name = string
  })
}

# Network - Subnet

variable "subnet" {
  description = "Subnet parameters"
  type = object({
    name       = string
    cidr       = string
    dhcp_start = string
    dhcp_end   = string
  })
}

# Network - Router

variable "router" {
  description = "Router Parameters"
  type = object({
    name = string
  })
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
