// Openstack project Id

variable "serviceName" {
 type           = string
}

variable "common" {
 type		= object({
	regions			= list(string)
	frontNwName		= string
	frontSubnetName		= string
	frontRouterName		= string
	backNwName		= string
	backNwVlanId		= number
	backSubnetName		= string
	backRouterName		= string
	portName		= string
	
	})
 default	= {
	regions			= ["GRA7","SBG5","GRA9"]
	frontNwName             = "frontNw"
        frontSubnetName         = "frontSubnet"
        frontRouterName         = "frontRouter"
	backNwName		= "backNw"
	backNwVlanId		= 100
	backSubnetName		= "backSubnet"
	backRouterName		= "backRouter"
	portName		= "frontPort"
	}
}

// Network regions parameters

variable "z" {
 type		= list(object({
      region		= string
      frontSubnetCIDR	= string
      backSubnetCIDR  	= string
      backRouterFrontIP = string
      backRouterBackIP	= string
		}))
 default	= [
        {
        	region          	= "GRA7"
		frontSubnetCIDR		= "192.168.10.0/24"
		backSubnetCIDR		= "192.168.110.0/24"
		backRouterFrontIP	= "192.168.10.254"
		backRouterBackIP	= "192.168.110.1"
        },{
        	region          	= "SBG5"
		frontSubnetCIDR		= "192.168.20.0/24"
		backSubnetCIDR  	= "192.168.120.0/24"
		backRouterFrontIP       = "192.168.20.254"
                backRouterBackIP        = "192.168.120.1"
        },{
                region          	= "GRA9"
                frontSubnetCIDR		= "192.168.30.0/24"
		backSubnetCIDR  	= "192.168.130.0/24"
		backRouterFrontIP       = "192.168.30.254"
                backRouterBackIP        = "192.168.130.1"
        }
   ]
}

