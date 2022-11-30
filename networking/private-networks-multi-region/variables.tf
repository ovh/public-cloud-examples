// Openstack project Id

variable "serviceName" {
 type           = string
}

// Network regions parameters

variable "z" {
 type		= list(object({
	region		= string
	pvNetworkName	= string
	subnetName	= string
	subnetCIDR      = string
	routerName	= string
		}))
 default	= [
        {
        	region          = "GRA7"
        	pvNetworkName   = "nw1"
		subnetName	= "sub1"
		subnetCIDR	= "192.168.10.0/24"
		routerName	= "rtr1"
        },{
        	region          = "SBG5"
        	pvNetworkName   = "nw2"
		subnetName      = "sub2"
		subnetCIDR      = "192.168.20.0/24"
		routerName	= "rtr2"
        },{
                region          = "GRA9"
                pvNetworkName   = "nw3"
                subnetName      = "sub3"
                subnetCIDR      = "192.168.30.0/24"
                routerName      = "rtr3"
        }
   ]
}

