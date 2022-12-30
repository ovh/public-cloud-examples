# Network common parameters

common = {
  regions           = ["GRA7", "SBG5", "GRA9"]
  mono_nw_name      = "monoNetwork"
  mono_subnet_name  = "monoSubnet"
  router_name       = "router"
  multi_nw_name     = "multiNetwork"
  multi_nw_vlan_id  = 100
  multi_subnet_name = "multiSubnet"
  portName          = "frontPort"
  multi_subnet_cidr = "172.16.0.0/16"
}

# Network by regions parameters

multi = [
  {
    region             = "GRA9"
    mono_subnet_cidr   = "192.168.10.0/24"
    router_mono_nw_ip  = "192.168.10.1"
    router_multi_nw_ip = "172.16.0.1"
    multi_subnet_start = "172.16.0.100"
    multi_subnet_end   = "172.16.63.254"
    mono_subnet_start  = "192.168.10.100"
    mono_subnet_end    = "192.168.10.200"
    }, {
    region             = "GRA7"
    mono_subnet_cidr   = "192.168.20.0/24"
    router_mono_nw_ip  = "192.168.20.1"
    router_multi_nw_ip = "172.16.64.1"
    multi_subnet_start = "172.16.64.100"
    multi_subnet_end   = "172.16.127.254"
    mono_subnet_start  = "192.168.20.100"
    mono_subnet_end    = "192.168.20.200"
    }, {
    region             = "SBG5"
    mono_subnet_cidr   = "192.168.30.0/24"
    router_mono_nw_ip  = "192.168.30.1"
    router_multi_nw_ip = "172.16.128.1"
    multi_subnet_start = "172.16.128.100"
    multi_subnet_end   = "172.16.255.254"
    mono_subnet_start  = "192.168.30.100"
    mono_subnet_end    = "192.168.30.200"
  }
]

# Network Routes

routes = [
  {
    region          = "GRA9"
    next_hop_route1 = "172.16.64.1"
    next_hop_route2 = "172.16.128.1"
    dest_route1     = "192.168.20.0/24"
    dest_route2     = "192.168.30.0/24"
    }, {
    region          = "GRA7"
    next_hop_route1 = "172.16.0.1"
    next_hop_route2 = "172.16.128.1"
    dest_route1     = "192.168.10.0/24"
    dest_route2     = "192.168.30.0/24"
    }, {
    region          = "SBG5"
    next_hop_route1 = "172.16.0.1"
    next_hop_route2 = "172.16.64.1"
    dest_route1     = "192.168.10.0/24"
    dest_route2     = "192.168.20.0/24"
  }
]

# SSH keypair

keypair = {
  name                 = "myKeyPair01"
  main_region          = "GRA9"
  to_reproduce_regions = ["GRA7", "SBG5"]
}

# Bastion Instance

bastion = {
  network_name = "monoNetwork"
  region       = "GRA9"
  name         = "bastion"
  flavor       = "b2-7"
  image        = "Ubuntu 20.04"
  user         = "ubuntu"
}

# Target Instance

target = {
  network_name = "monoNetwork"
  region       = "GRA7"
  name         = "target"
  flavor       = "b2-7"
  image        = "Ubuntu 20.04"
  user         = "ubuntu"
}
