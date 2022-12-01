// Openstack project Id

variable "serviceName" {
  type = string
}


// Kubernetes Cluster Name

variable "clusterName" {
  type = string
}

// Region

variable "region" {
  type = string
}

// Network - Private Network

variable "pvNetworkName" {
  type = string
}

variable "rtrIp" {
  type = string
}

// Node Pool definition

variable "myPoolName" {
  type = string
}

variable "myPoolFlavor" {
  type = string
}

variable "myPoolDesiredNodes" {
  type = string
}

variable "myPoolMaxNodes" {
  type = string
}

variable "myPoolMinNodes" {
  type = string
}
