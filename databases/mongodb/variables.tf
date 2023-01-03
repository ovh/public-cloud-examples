# Openstack project Id

variable "service_name" {
  description = "Service Name"
  type        = string
}

# Region

variable "region" {
  description = "Region"
  type        = string
}

# Region for database

variable "db_region" {
  description = "Database Region"
  type        = string
}

# Network - Private Network

variable "pv_network_name" {
  description = "Private Network Name"
  type        = string
}

# Network - Subnet

variable "subnet_name" {
  description = "Subnet Name"
  type        = string
}

# Database

variable "db_description" {
  description = "Database Description"
  type        = string
}

variable "db_engine" {
  description = "Db Engine"
  type        = string
}

variable "db_version" {
  description = "Db Version"
  type        = string
}

variable "db_plan" {
  description = "Db Plan"
  type        = string
}

variable "db_flavor" {
  description = "Db Flavor"
  type        = string
}

# Database User

variable "db_user_name" {
  description = "Db User Name"
  type        = string
}

variable "db_user_role" {
  description = "Db User Role"
  type        = list(any)
}

# IP Restriction

variable "db_allowed_ip" {
  description = "Db Allowed IPs"
  type        = string
}
