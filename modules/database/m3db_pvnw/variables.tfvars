# Region

region = "GRA7"

# Database Engine

db_engine = {
  region          = "GRA"
  pv_network_name = "myNetwork"
  subnet_name     = "mySubnet"
  description     = "metricsDB"
  engine          = "m3db"
  version         = "1.5"
  plan            = "essential"
  flavor          = "db1-7"
  allowed_ip      = ["192.168.29.0/24"]
}

user = {
  name           = "metrics"
  group          = "metrics"
  password_reset = "ChangeMeToResetPassword"
}

namespace = {
  name                      = "metricsns"
  resolution                = "P2D"
  retention_period_duration = "PT48H"
}
