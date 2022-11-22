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
 type = list
 description = "List of instances"
 default = []
}
