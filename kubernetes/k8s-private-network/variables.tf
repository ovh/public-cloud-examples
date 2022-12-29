# Openstack project Id

variable "serviceName" {
  description = "Service Name"
  type        = string
}


# Kubernetes Cluster Name

variable "clusterName" {
  description = "Cluster Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Network - Private Network

variable "pvNetworkName" {
  description = "Private Network Name"
  type        = string
}

variable "rtrIp" {
  description = "Router Ip"
  type        = string
}

# Node Pool definition

variable "myPoolName" {
  description = "Pool Name"
  type        = string
}

variable "myPoolFlavor" {
  description = "Pool Flavor"
  type        = string
}

variable "myPoolDesiredNodes" {
  description = "Pool Desired Nodes"
  type        = string
}

variable "myPoolMaxNodes" {
  description = "Pool Max Nodes"
  type        = string
}

variable "myPoolMinNodes" {
  description = "Pool Min Nodes"
  type        = string
}
