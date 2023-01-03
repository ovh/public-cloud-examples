# OVHcloud Simple instance Module

Simple module to create an instance that is connected to an existing private network and add an existing public SSH key to the defined user home directory.

# Usage

```terraform
module "instance" {
  source     = "../../modules/instance_simple"
  instance   = var.instance
}
```

# Variables

## instance

`instance` is an object type variable:

```terraform
variable "instance" {
  description = "Instance Parameters"
  type = object({
    region       = string
    network_name = string
    keypair_name = string
    name         = string
    flavor       = string
    image        = string
    user         = string
  })
}
```

### region

The region where the instance is deployed.

### network_name

The network on wich the instance is connected.

### keypair_name

The SSH keypair name that is deployed to to the user home directory

### name

The name of the instance.

### flavor

The flavor type of the instance.

Get the full list here: TODO

### image

The image name of the instance.

Get the full list here: TODO

### user

The user that is created on the instance.
