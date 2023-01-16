# Region

region = "GRA9"

# Database Engine

db_engine = {
  region          = "GRA"
  pv_network_name = "devNetwork"
  subnet_name     = "devSubnet"
  description     = "pgsqlExample"
  engine          = "postgresql"
  version         = "14"
  plan            = "business"
  flavor          = "db1-7"
  allowed_ip      = ["192.168.75.0/24"]
}

user = {
  name           = "pguser"
  roles          = ["replication"]
  password_reset = "ChangeMeToResetPassword"
}
