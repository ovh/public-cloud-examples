# Network common parameters

common = {
  regions         = ["GRA7", "SBG5", "GRA9"]
  frontNwName     = "frontNw"
  frontSubnetName = "frontSubnet"
  frontRouterName = "frontRouter"
  backNwName      = "backNw"
  backNwVlanId    = 100
  backSubnetName  = "backSubnet"
  backRouterName  = "backRouter"
  portName        = "frontPort"
}

# Network by regions parameters

multi = [
  {
    region            = "GRA7"
    frontSubnetCIDR   = "192.168.10.0/24"
    backSubnetCIDR    = "192.168.110.0/24"
    backRouterFrontIP = "192.168.10.254"
    backRouterBackIP  = "192.168.110.1"
    }, {
    region            = "SBG5"
    frontSubnetCIDR   = "192.168.20.0/24"
    backSubnetCIDR    = "192.168.120.0/24"
    backRouterFrontIP = "192.168.20.254"
    backRouterBackIP  = "192.168.120.1"
    }, {
    region            = "GRA9"
    frontSubnetCIDR   = "192.168.30.0/24"
    backSubnetCIDR    = "192.168.130.0/24"
    backRouterFrontIP = "192.168.30.254"
    backRouterBackIP  = "192.168.130.1"
  }
]

# SSH keypair

keypair = {
  keypairName               = "myKeyPair01"
  keypairMainRegion         = "GRA9"
  keypairToReproduceRegions = ["GRA7", "SBG5"]
}

# Bastion Instance

bastion = {
  frontNwName   = "frontNw"
  bRegion       = "GRA9"
  bSubnetCIDR   = "192.168.30.0/24"
  bRtrIp        = "192.168.30.1"
  bastionName   = "bastion"
  bastionFlavor = "b2-7"
  bastionImage  = "Ubuntu 20.04"
  bastionUser   = "ubuntu"
  bastionIP     = "192.168.30.2"
}

# Back Instance

back = {
  backNwName  = "backNw"
  bRegion     = "SBG5"
  bSubnetCIDR = "192.168.120.0/24"
  bRtrIp      = "192.168.120.1"
  backName    = "back"
  backFlavor  = "b2-7"
  backImage   = "Ubuntu 20.04"
  backUser    = "ubuntu"
  backIP      = "192.168.120.2"
}
