variable "keypairAdmin" {
 type = string
}

variable "imageId" {
 type = string
 default = "680bf266-52a2-4794-a3b7-9bb30a933bdc"
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
