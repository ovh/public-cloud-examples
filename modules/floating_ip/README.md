# OVHcloud Floating IP Module

Simple module to associate an Openstack Floating IP to an Openstack resource.

This module will create the floating IP from the `Ext-Net` public network associated to the given region, and then create the association to the given component id.

# Usage

```terraform
module "floatip" {
  source     = "../../modules/floating_ip"
  floatip = {
    region       = "<REGION>"
    component_id = "<OPENSTACK COMPONENT ID>"
  }
}
```

# Variables

## floatip

`floatip` is an object type variable, with two string parameters.

```terraform
variable "floatip" {
  description = "Floating IP"
  type = object({
    region       = string
    component_id = string
  })
  default = {
    region       = ""
    component_id = ""
  }
}
```

### region

The `region` where the floating IP is deployed.

### component_id

The Openstack id of the component to associate the floating IP to.

> Note: This id is often unknown, so this variable cannot be setted into a tfvars file. That's why you have to declare the `floatip` variable into the main.tf file (or other .tf file)

# Example

Example: Associate a floating IP to an instance.

```terraform
module "bastion" {
  source     = "../../modules/instance_simple"
  instance   = var.bastion
}

module "floatip" {
  source     = "../../modules/floating_ip"
  depends_on = [module.bastion]
  floatip = {
    region       = var.region
    component_id = module.bastion.instance_id
  }
}
```
