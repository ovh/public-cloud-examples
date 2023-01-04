# Example 01

![Example 01 schema](./img/01.png)

Private network with : 

- Subnet with a defined DHCP range

- Virtual router as gateway

SSH keypair

Virtual Machine Instance

Floating IP

## Description

This example show you how create an access to a virtual machine that is connected to a private network with [Terraform](https://www.terraform.io).

## Pre-requisites

Follow the [Starting Pack to manage your OVHcloud Services from shell](../../basics/README.md) tutorial to make your terraform client working with your [OVHcloud Public Cloud project](https://www.ovhcloud.com/en-gb/public-cloud).

## Variables

Create (or modify the existing one) a file `variables.tfvars` and add the following parts:

### Region part

The region where this example is deployed.

Example : 

```terraform
region = "GRA7"
```

### Networking part

This variables are needed by the [private network module](../../modules/private_network)

#### Private Network

```terraform
network = {
  name = "myNetwork"
}
```

- name: The private network only need a name to be configured

#### Subnet

```terraform
subnet = {
  name       = "mySubnet"
  cidr       = "192.168.12.0/24"
  dhcp_start = "192.168.12.100"
  dhcp_end   = "192.168.12.254"
}
```

- name: The subnet name.

- cidr: The subnet networking range, CIDR format.

- dhcp_start: The first IP address of the DHCP range.

- dhcp_end: The last IP address of the DHCP range.


#### Virtual Router

```terraform
router = {
  name = "myRouter"
}
```

- name: The virtual router only need a name to be configured.

> Note: The router will be connected to the `Ext-Net` network associated to the given region, and to the private network. Its private IP address is automaticly the first of the subnet CIDR range.

### SSH keypair part

```terraform
keypair = {
  name                 = "myMainKeypair"
  main_region          = "GRA7"
  to_reproduce_regions = []
  keys_path            = "."
}
```

This variables are needed by the [private network module](../../modules/ssh_keypair)

- name: The keypair name.

- main_region: The region where the SSH keypair is deployed.

- to_reproduce_regions: (Not applicable in this example, let the `[]` value) Add another regions if you want to deploy the created SSH public key inside.

- keys_path: The path where the SSH private and public keys files will be created. 

#### Virtual Machine part

This variables are needed by the [private network module](../../modules/instance_simple)

```terraform
bastion = {
  region       = "GRA7"
  network_name = "myNetwork"
  keypair_name = "myMainKeypair"
  name         = "bastion"
  flavor       = "b2-7"
  image        = "Ubuntu 20.04"
  user         = "ubuntu"
}
```

As this instance is only created to access to the private network components, it is called `bastion`.

- region: The region where this instance is deployed, must be the same value as the network and SSH keypair modules.

- network_name: The name of the private network, as previously defined.

- keypair_name: The name of the SSH keypair, as previously defined.

- flavor: The flavor type of the instance. Get the full list of possible values here: TODO

- image: The OS image of the instance. Get the full list of possible values here: TODO

- user: The linux user created on the instance. The SSH public key will be deployed.

## Deploy 

```bash
terraform init
terraform plan -var-file=variables.tfvars
terraform apply -var-file=variables.tfvars
```

<details><summary> 📍 Output (click to expand)</summary>
```log
$ terraform init
Initializing modules...
- bastion in ../../modules/instance_simple
- floatip in ../../modules/floating_ip
- keypair in ../../modules/ssh_keypair
- network in ../../modules/private_network

Initializing the backend...

Initializing provider plugins...
- Finding terraform-provider-openstack/openstack versions matching "~> 1.49.0"...
- Finding hashicorp/local versions matching "~> 2.2.3"...
- Installing terraform-provider-openstack/openstack v1.49.0...
- Installed terraform-provider-openstack/openstack v1.49.0 (self-signed, key ID 4F80527A391BEFD2)
- Installing hashicorp/local v2.2.3...
- Installed hashicorp/local v2.2.3 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
</summary>

## Usage

Once deployed, get the Floating IP address value from the output value ``

## Destroy

```bash
terraform destroy -var-file=variables.tfvars
```
