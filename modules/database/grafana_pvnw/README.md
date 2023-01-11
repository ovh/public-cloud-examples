# OVHcloud Managed Grafana connected to Private Network

This module create a Managed Grafana that is connected to a private network.

# Usage

```terraform
module "grafana" {
  source    = "../../modules/database/grafana_pvnw"
  region    = var.region
  db_engine = var.db_engine
}
```

# Variables

## db_engine

`db_engine` is an object type variable:

```terraform
variable "db_engine" {
  description = "Db Engine parameters"
  type = object({
    region          = string
    pv_network_name = string
    subnet_name     = string
    description     = string
    engine          = string
    version         = string
    plan            = string
    flavor          = string
    allowed_ip      = list(string)
  })
}
```

- `region`: The region where the db engine is deployed. Get the region full list on the [capabilities](https://docs.ovh.com/gb/en/publiccloud/databases/mongodb/capabilities/) page.

- `pv_network_name`: The name of an existing private network.

- `subnet_name`: The name of the subnet.

- `description`: The name of the database engine.`:

- `engine`: The database engine type.

- `version`: The database engine version.

- `plan`: The database engine plan.

- `flavor`: The nodes flavor type.

- `allowed_ip`: The list of IP adresse(s) allowed to connect to the database engine (CIDR format).

## Example

```terraform
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
```
