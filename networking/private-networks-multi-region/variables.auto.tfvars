# Network common parameters

common = {
  regions         = ["GRA7", "SBG5", "GRA9"]
  monoNwName      = "monoNetwork"
  monoSubnetName  = "monoSubnet"
  routerName      = "router"
  multiNwName     = "multiNetwork"
  multiNwVlanId   = 100
  multiSubnetName = "multiSubnet"
  backRouterName  = "backRouter"
  portName        = "frontPort"
  multiSubnetCIDR = "172.16.0.0/16"
}

# Network by regions parameters

multi = [
  {
    region           = "GRA9"
    monoSubnetCIDR   = "192.168.10.0/24"
    routerMonoNwIP   = "192.168.10.1"
    routerMultiNwIP  = "172.16.0.1"
    multiSubnetStart = "172.16.0.2"
    multiSubnetEnd   = "172.16.63.254"
    }, {
    region           = "GRA7"
    monoSubnetCIDR   = "192.168.20.0/24"
    routerMonoNwIP   = "192.168.20.1"
    routerMultiNwIP  = "172.16.64.1"
    multiSubnetStart = "172.16.64.2"
    multiSubnetEnd   = "172.16.127.254"
    }, {
    region           = "SBG5"
    monoSubnetCIDR   = "192.168.30.0/24"
    routerMonoNwIP   = "192.168.30.1"
    routerMultiNwIP  = "172.16.128.1"
    multiSubnetStart = "172.16.128.2"
    multiSubnetEnd   = "172.16.255.254"
  }
]

# Network Routes

routes = [
  {
    region        = "GRA9"
    nextHopRoute1 = "172.16.64.1"
    nextHopRoute2 = "172.16.128.1"
    destRoute1    = "192.168.20.0/24"
    destRoute2    = "192.168.30.0/24"
    }, {
    region        = "GRA7"
    nextHopRoute1 = "172.16.0.1"
    nextHopRoute2 = "172.16.128.1"
    destRoute1    = "192.168.10.0/24"
    destRoute2    = "192.168.30.0/24"
    }, {
    region        = "SBG5"
    nextHopRoute1 = "172.16.0.1"
    nextHopRoute2 = "172.16.64.1"
    destRoute1    = "192.168.10.0/24"
    destRoute2    = "192.168.20.0/24"
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
  networkName     = "monoNetwork"
  region          = "GRA9"
  subnetCIDR      = "192.168.10.0/24"
  rtrIp           = "192.168.10.1"
  name            = "bastion"
  flavor          = "b2-7"
  image           = "Ubuntu 20.04"
  user            = "ubuntu"
  fixedIP         = "192.168.10.2"
  subnetMultiCIDR = "172.16.0.0/16"
}

# Target Instance

target = {
  networkName     = "monoNetwork"
  region          = "GRA7"
  subnetCIDR      = "192.168.20.0/24"
  rtrIp           = "192.168.20.1"
  name            = "target"
  flavor          = "b2-7"
  image           = "Ubuntu 20.04"
  user            = "ubuntu"
  fixedIP         = "192.168.20.2"
  subnetMultiCIDR = "172.16.0.0/16"
}
