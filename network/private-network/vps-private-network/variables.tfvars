# Region

region = "GRA7"

# Network - Private Network

network = {
  name = "myNetwork"
}

# Network - Subnet

subnet = {
  name       = "mySubnet"
  cidr       = "192.168.12.0/24"
  dhcp_start = "192.168.12.100"
  dhcp_end   = "192.168.12.254"
}

# Network - Router

router = {
  name = "myRouter"
}

# SSH Keypair

keypair = {
  name                 = "myMainKeypair"
  main_region          = "GRA7"
  to_reproduce_regions = []
  keys_path            = "."
}

# Instance - bastion

bastion = {
  region       = "GRA7"
  network_name = "myNetwork"
  keypair_name = "myMainKeypair"
  name         = "bastion"
  flavor       = "b2-7"
  image        = "Ubuntu 20.04"
  user         = "ubuntu"
}
