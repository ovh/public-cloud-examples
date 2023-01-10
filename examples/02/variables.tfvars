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

# Database Engine

db_engine = {
  region          = "GRA"
  pv_network_name = "myNetwork"
  subnet_name     = "mySubnet"
  description     = "myMongoDb"
  engine          = "mongodb"
  version         = "6.0"
  plan            = "business"
  flavor          = "db1-7"
  user_name       = "myuser"
  user_role       = ["readWriteAnyDatabase"]
  allowed_ip      = ["192.168.12.0/24"]
}

# SSH Keypair

keypair = {
  name                 = "myMainKeypair"
  main_region          = "GRA7"
  to_reproduce_regions = []
  keys_path            = "."
}

# Instance - instance

instance = {
  region       = "GRA7"
  network_name = "myNetwork"
  keypair_name = "myMainKeypair"
  name         = "myserver"
  flavor       = "b2-7"
  image        = "Ubuntu 20.04"
  user         = "ubuntu"
}
