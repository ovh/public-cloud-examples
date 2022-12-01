// Openstack project Id

variable "serviceName" {
  type = string
}

// Region

variable "region" {
  type = string
}

// Region for database

variable "dbRegion" {
  type = string
}

// Network - Private Network

variable "pvNetworkName" {
  type = string
}

// Network - Subnet

variable "subnetName" {
  type = string
}

// Database

variable "dbDescription" {
  type = string
}

variable "dbEngine" {
  type = string
}

variable "dbVersion" {
  type = string
}

variable "dbPlan" {
  type = string
}

variable "dbFlavor" {
  type = string
}

// Database User

variable "dbUserName" {
  type = string
}

variable "dbUserRole" {
  type = list(any)
}

// IP Restriction

variable "dbAllowedIp" {
  type = string
}
