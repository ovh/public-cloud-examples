# OVHcloud Managed MongoDB connected to Private Network

This module create a Managed MongoDb, with user and acl, that is connected to a private network.

# Usage

```terraform
# Managed MongoDB Database
module "db_engine" {
  source     = "../../modules/database/mongodb_pvnw"
  region     = var.region
  db_engine  = var.db_engine
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
    user_name       = string
    user_role       = list(string)
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

- `user_name`: The user that will be created on the database engine.

- `user_role`: The list of given roles to the user.

- `allowed_ip`: The list of IP adresse(s) allowed to connect to the database engine (CIDR format).

## Example

```terraform
# Region

region = "GRA7"

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
```
