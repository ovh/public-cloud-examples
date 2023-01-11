# OVHcloud Managed M3DB connected to Private Network

This module create a Managed M3DB, with user and namespace, that is connected to a private network.

# Usage

```terraform
module "m3db" {
  source    = "../../modules/database/m3db_pvnw"
  region    = var.region
  db_engine = var.db_engine
  user      = var.user
  namespace = var.namespace
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

- `description`: The name of the database engine.

- `engine`: The database engine type.

- `version`: The database engine version.

- `plan`: The database engine plan.

- `flavor`: The nodes flavor type.

- `allowed_ip`: The list of IP adresse(s) allowed to connect to the database engine (CIDR format).

## User

`user` is an object type variable:

```terraform
variable "user" {
  description = "Db User"
  type = object({
    name           = string
    group          = string
    password_reset = string
  })
}
```

- `name`: The user name.

- `group`: The user group.

- `password_reset`: A random value, change it to initiate a passorwd reset.

## Namespace

`namespace` is an object type variable:

```terraform
variable "namespace" {
  description = "M3DB Namespace parameters"
  type = object({
    name                      = string
    resolution                = string
    retention_period_duration = string
  })
}
```

- `name`: The namespace name.

- `resolution`: The namespace resolution.

- `retention_period_duration`: The namespace period duration.

## Example

```terraform
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
```
