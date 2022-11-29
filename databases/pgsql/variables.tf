// Openstack project Id

variable "serviceName" {
 type           = string
}

// Region

variable "region" {
 type 		= string
 default	= "GRA7"
}

// Region for database

variable "dbRegion" {
 type           = string
 default        = "GRA"
}

// Network - Private Network

variable "pvNetworkName" {
 type 		= string
 default 	= "myPrivateNetwork"
}

// Network - Subnet

variable "subnetName" {
 type           = string
 default        = "mySubnet"
}

// Database

variable "dbDescription" {
 type		= string
 default	= "myPgSqlDb"
}

variable "dbEngine" {
 type           = string
 default        = "postgresql"
}

variable "dbVersion" {
 type           = string
 default        = "14"
}

variable "dbPlan" {
 type           = string
 default        = "business"
}

variable "dbFlavor" {
 type           = string
 default        = "db1-7"
}

// Database User

variable "dbUserName" {
 type           = string
 default        = "myuser"
}

variable "dbUserRole" {
 type		= list
 default	= ["replication"]
}

// IP Restriction

variable "dbAllowedIp" {
 type		= string
 default	= "192.168.2.0/24"
}
