# Openstack project Id

variable "serviceName" {
  description = "Service Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Region for database

variable "dbRegion" {
  description = "Db region"
  type        = string
}

# Network - Private Network

variable "pvNetworkName" {
  description = "Private Network Name"
  type        = string
}

# Network - Subnet

variable "subnetName" {
  description = "Subnet Name"
  type        = string
}

# Database

variable "dbDescription" {
  description = "Db Description"
  type        = string
}

variable "dbEngine" {
  description = "Db Engine"
  type        = string
}

variable "dbVersion" {
  description = "Db Version"
  type        = string
}

variable "dbPlan" {
  description = "Db Plan"
  type        = string
}

variable "dbFlavor" {
  description = "Db Flavor"
  type        = string
}

# Database User

variable "dbUserName" {
  description = "Db User Name"
  type        = string
}

variable "dbUserRole" {
  description = "Db User Role"
  type        = list(any)
}

# IP Restriction

variable "dbAllowedIp" {
  description = "Db Allowed Ips"
  type        = string
}
