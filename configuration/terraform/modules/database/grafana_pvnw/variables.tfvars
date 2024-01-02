# Region

region = "GRA7"

# Grafana

db_engine = {
  region          = "GRA"
  pv_network_name = "myNetwork"
  subnet_name     = "mySubnet"
  description     = "grafamoi"
  engine          = "grafana"
  version         = "9.1"
  plan            = "essential"
  flavor          = "db1-7"
  allowed_ip      = ["192.168.29.0/24"]
}
