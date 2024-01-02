# Region

region = "GRA7"

# Database Engine

db_engine = {
  region          = "GRA"
  pv_network_name = "myNetwork"
  subnet_name     = "mySubnet"
  description     = "myMysqlDb"
  engine          = "mysql"
  version         = "8"
  plan            = "business"
  flavor          = "db1-7"
  user_name       = "myuser"
  allowed_ip      = ["192.168.12.0/24"]
}

db = {
  name = "wordpressDb"
}
