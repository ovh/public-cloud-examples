// Openstack project Id

variable "serviceName" {
 type           = string
}

// Region

variable "region" {
 type 		= string
 default	= "GRA9"
}

// Network - Private Network

variable "pvNetworkName" {
 type 		= string
 default 	= "myPrivateNetwork"
}

variable "pvNetworkId" {
 type 		= string
 default	= "30"
}

// Network - Subnet

variable "subnetName" {
 type 		= string
 default	= "mySubnet"
}

variable "subnetCIDR" {
 type 		= string
 default	= "192.168.2.0/24"
}

variable "subnetDHCPStart" {
 type 		= string
 default	= "192.168.2.200"
}

variable "subnetDHCPEnd" {
 type 		= string
 default 	= "192.168.2.254"
}

// Network - Router

variable "rtrName" {
 type 		= string
 default	= "myRouter"
}

variable "rtrIp" {
 type 		= string
 default	= "192.168.2.1"
}
