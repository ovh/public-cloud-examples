// Openstack project Id

variable "serviceName" {
 type           = string
}


// Kubernetes Cluster Name

variable "clusterName" {
 type		= string
 default	= "myKubernetesCluster"
}

// Region

variable "region" {
 type 		= string
 default	= "GRA7"
}

// Network - Private Network

variable "pvNetworkName" {
 type 		= string
 default 	= "myPrivateNetwork"
}

variable "rtrIp" {
 type 		= string
 default	= "192.168.2.1"
}

// Node Pool definition

variable "myPoolName" {
 type           = string
 default        = "mypool"
}

variable "myPoolFlavor" {
 type           = string
 default        = "b2-7"
}

variable "myPoolDesiredNodes" {
 type           = string
 default        = "3"
}

variable "myPoolMaxNodes" {
 type           = string
 default        = "6"
}

variable "myPoolMinNodes" {
 type           = string
 default        = "3"
}
