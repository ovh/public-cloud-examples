variable "keypairAdmin" {
  description = "Admin Keypair Name"
  type        = string
}

variable "imageId" {
  description = "Image Id"
  type        = string
}

variable "flavorId" {
  description = "Flavor Id"
  type        = string
}

variable "nameList" {
  type        = list(any)
  description = "List of instances"
  default     = []
}
