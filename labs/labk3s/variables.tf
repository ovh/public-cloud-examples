variable "keypairAdmin" {
 type = string
}

variable "imageId" {
 type = string
 default = "832e22a6-e665-4b7d-a625-5413a2833a5b"
}

variable "flavorId" {
 type = string
 default = "906e8259-0340-4856-95b5-4ea2d26fe377"
}

variable "nameList" {
 type = list
 description = "List of instances"
 default = [
"k3s001",
"k3s002",
"k3s003",
 ]
}
