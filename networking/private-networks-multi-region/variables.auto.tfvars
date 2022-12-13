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
  backSubnetCIDR  = "172.16.0.0/16"
}

# Network by regions parameters

multi = [
  {
    region             = "GRA9"
    frontSubnetCIDR    = "192.168.10.0/24"
    frontRouterFrontIP = "192.168.10.1"
    backRouterFrontIP  = "192.168.10.254"
    backRouterBackIP   = "172.16.0.1"
    backSubnetStart    = "172.16.0.2"
    backSubnetEnd      = "172.16.63.254"
    }, {
    region             = "GRA7"
    frontSubnetCIDR    = "192.168.20.0/24"
    frontRouterFrontIP = "192.168.20.1"
    backRouterFrontIP  = "192.168.20.254"
    backRouterBackIP   = "172.16.64.1"
    backSubnetStart    = "172.16.64.2"
    backSubnetEnd      = "172.16.127.254"
    }, {
    region             = "SBG5"
    frontSubnetCIDR    = "192.168.30.0/24"
    frontRouterFrontIP = "192.168.30.1"
    backRouterFrontIP  = "192.168.30.254"
    backRouterBackIP   = "172.16.128.1"
    backSubnetStart    = "172.16.128.2"
    backSubnetEnd      = "172.16.255.254"
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
  frontNwName    = "frontNw"
  bRegion        = "GRA9"
  bSubnetCIDR    = "192.168.10.0/24"
  bRtrIp         = "192.168.10.1"
  bGateway       = "192.168.10.254"
  bastionName    = "bastion"
  bastionFlavor  = "b2-7"
  bastionImage   = "Ubuntu 20.04"
  bastionUser    = "ubuntu"
  bastionIP      = "192.168.10.2"
  backSubnetCIDR = "172.16.0.0/16"
}

# Target Instance

target = {
  frontNwName    = "frontNw"
  bRegion        = "GRA7"
  bSubnetCIDR    = "192.168.20.0/24"
  bRtrIp         = "192.168.20.1"
  bGateway       = "192.168.20.254"
  targetName     = "target"
  targetFlavor   = "b2-7"
  targetImage    = "Ubuntu 20.04"
  targetUser     = "ubuntu"
  targetIP       = "192.168.20.2"
  backSubnetCIDR = "172.16.0.0/16"
}
