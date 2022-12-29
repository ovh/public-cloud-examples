variable "keypairAdmin" {
  type = string
}

variable "imageId" {
  type = string
}

variable "flavorId" {
  type = string
}

variable "nameList" {
  type        = list(any)
  description = "List of instances"
  default     = []
}
