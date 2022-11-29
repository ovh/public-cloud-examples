// Openstack project Id

variable "serviceName" {
 type           = string
}

// Region

variable "region" {
 type 		= string
 default	= "GRA7"
}

// Block Storage Volume

variable "bsName" {
 type		= string
 default	= "my-block-storage-volume"
}

variable "bsSize" {
 type           = number
 default        = 100
}
