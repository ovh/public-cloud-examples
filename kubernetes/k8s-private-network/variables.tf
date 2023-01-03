# Openstack project Id

variable "service_name" {
  description = "Service Name"
  type        = string
}


# Kubernetes Cluster Name

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "pv_network_name" {
  description = "Private Network Name"
  type        = string
}

variable "rtr_ip" {
  description = "Router Ip"
  type        = string
}

# Node Pool definition

variable "my_pool_name" {
  description = "Pool Name"
  type        = string
}

variable "my_pool_flavor" {
  description = "Pool Flavor"
  type        = string
}

variable "my_pool_desired_nodes" {
  description = "Pool Desired Nodes"
  type        = string
}

variable "my_pool_max_nodes" {
  description = "Pool Max Nodes"
  type        = string
}

variable "my_pool_min_nodes" {
  description = "Pool Min Nodes"
  type        = string
}
