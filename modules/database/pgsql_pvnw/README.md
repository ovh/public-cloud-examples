# OVHcloud Managed PostgreSQL connected to Private Network

This module create a Managed PostgreSQL, with user, that is connected to a private network.

# Usage

```terraform
module "postgre" {
  source     = "../../modules/database/postgresql_pvnw"
  depends_on = [module.network]
  region     = var.region
  db_engine  = var.db_engine
  user       = var.user
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

- `region`: The region where the db engine is deployed. Get the region full list on the [capabilities](https://docs.ovh.com/gb/en/publiccloud/databases/postgresql/capabilities/) page.

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
    roles          = list(string)
    password_reset = string
  })
}
```

- `name`: The user name.

- `group`: The user group.

- `password_reset`: A random value, change it to initiate a passorwd reset.

## Example

```terraform
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
```
