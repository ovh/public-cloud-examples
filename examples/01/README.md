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

```bash
terraform plan -var-file=variables.tfvars
```

<details><summary> 📍 Output (click to expand)</summary>

```log
$ terraform plan -var-file=variables.tfvars
module.network.data.openstack_networking_network_v2.ext_net: Reading...
module.network.data.openstack_networking_network_v2.ext_net: Read complete after 2s [id=xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.bastion.openstack_compute_instance_v2.simple_instance will be created
  + resource "openstack_compute_instance_v2" "simple_instance" {
      + access_ip_v4        = (known after apply)
      + access_ip_v6        = (known after apply)
      + all_metadata        = (known after apply)
      + all_tags            = (known after apply)
      + availability_zone   = (known after apply)
      + created             = (known after apply)
      + flavor_id           = (known after apply)
      + flavor_name         = "b2-7"
      + force_delete        = false
      + id                  = (known after apply)
      + image_id            = (known after apply)
      + image_name          = "Ubuntu 20.04"
      + key_pair            = "myMainKeypair"
      + name                = "bastion"
      + power_state         = "active"
      + region              = "GRA7"
      + security_groups     = [
          + "default",
        ]
      + stop_before_destroy = false
      + updated             = (known after apply)

      + network {
          + access_network = false
          + fixed_ip_v4    = (known after apply)
          + fixed_ip_v6    = (known after apply)
          + floating_ip    = (known after apply)
          + mac            = (known after apply)
          + name           = "myNetwork"
          + port           = (known after apply)
          + uuid           = (known after apply)
        }
    }

  # module.floatip.openstack_compute_floatingip_associate_v2.floatip_association will be created
  + resource "openstack_compute_floatingip_associate_v2" "floatip_association" {
      + floating_ip = (known after apply)
      + id          = (known after apply)
      + instance_id = (known after apply)
      + region      = "GRA7"
    }

  # module.floatip.openstack_networking_floatingip_v2.floatip will be created
  + resource "openstack_networking_floatingip_v2" "floatip" {
      + address    = (known after apply)
      + all_tags   = (known after apply)
      + dns_domain = (known after apply)
      + dns_name   = (known after apply)
      + fixed_ip   = (known after apply)
      + id         = (known after apply)
      + pool       = "Ext-Net"
      + port_id    = (known after apply)
      + region     = "GRA7"
      + subnet_id  = (known after apply)
      + tenant_id  = (known after apply)
    }

  # module.keypair.local_file.ssh_private_key will be created
  + resource "local_file" "ssh_private_key" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "./myMainKeypair_rsa"
      + id                   = (known after apply)
    }

  # module.keypair.local_file.ssh_public_key will be created
  + resource "local_file" "ssh_public_key" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "./myMainKeypair_rsa.pub"
      + id                   = (known after apply)
    }

  # module.keypair.openstack_compute_keypair_v2.main_keypair will be created
  + resource "openstack_compute_keypair_v2" "main_keypair" {
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + name        = "myMainKeypair"
      + private_key = (known after apply)
      + public_key  = (known after apply)
      + region      = "GRA7"
      + user_id     = (known after apply)
    }

  # module.network.openstack_networking_network_v2.my_private_network will be created
  + resource "openstack_networking_network_v2" "my_private_network" {
      + admin_state_up          = true
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + dns_domain              = (known after apply)
      + external                = (known after apply)
      + id                      = (known after apply)
      + mtu                     = (known after apply)
      + name                    = "myNetwork"
      + port_security_enabled   = (known after apply)
      + qos_policy_id           = (known after apply)
      + region                  = "GRA7"
      + shared                  = (known after apply)
      + tenant_id               = (known after apply)
      + transparent_vlan        = (known after apply)
    }

  # module.network.openstack_networking_router_interface_v2.my_router_interface will be created
  + resource "openstack_networking_router_interface_v2" "my_router_interface" {
      + id        = (known after apply)
      + port_id   = (known after apply)
      + region    = "GRA7"
      + router_id = (known after apply)
      + subnet_id = (known after apply)
    }

  # module.network.openstack_networking_router_v2.my_router will be created
  + resource "openstack_networking_router_v2" "my_router" {
      + admin_state_up          = true
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + distributed             = (known after apply)
      + enable_snat             = (known after apply)
      + external_gateway        = (known after apply)
      + external_network_id     = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx"
      + id                      = (known after apply)
      + name                    = "myRouter"
      + region                  = "GRA7"
      + tenant_id               = (known after apply)

      + external_fixed_ip {
          + ip_address = (known after apply)
          + subnet_id  = (known after apply)
        }
    }

  # module.network.openstack_networking_subnet_v2.my_subnet will be created
  + resource "openstack_networking_subnet_v2" "my_subnet" {
      + all_tags          = (known after apply)
      + cidr              = "192.168.12.0/24"
      + dns_nameservers   = [
          + "1.1.1.1",
          + "1.0.0.1",
        ]
      + enable_dhcp       = true
      + gateway_ip        = (known after apply)
      + id                = (known after apply)
      + ip_version        = 4
      + ipv6_address_mode = (known after apply)
      + ipv6_ra_mode      = (known after apply)
      + name              = "mySubnet"
      + network_id        = (known after apply)
      + no_gateway        = false
      + region            = "GRA7"
      + service_types     = (known after apply)
      + tenant_id         = (known after apply)

      + allocation_pool {
          + end   = "192.168.12.254"
          + start = "192.168.12.100"
        }

      + allocation_pools {
          + end   = (known after apply)
          + start = (known after apply)
        }
    }

Plan: 10 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bastion_floating_ip = (known after apply)
  + bastion_private_ip  = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly
these actions if you run "terraform apply" now.
```

</details>

```bash
terraform apply -var-file=variables.tfvars
```

<details><summary> 📍 Output (click to expand)</summary>

```log
$ terraform apply -var-file=variables.tfvars
module.network.data.openstack_networking_network_v2.ext_net: Reading...
module.network.data.openstack_networking_network_v2.ext_net: Read complete after 2s [id=xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.bastion.openstack_compute_instance_v2.simple_instance will be created
  + resource "openstack_compute_instance_v2" "simple_instance" {
      + access_ip_v4        = (known after apply)
      + access_ip_v6        = (known after apply)
      + all_metadata        = (known after apply)
      + all_tags            = (known after apply)
      + availability_zone   = (known after apply)
      + created             = (known after apply)
      + flavor_id           = (known after apply)
      + flavor_name         = "b2-7"
      + force_delete        = false
      + id                  = (known after apply)
      + image_id            = (known after apply)
      + image_name          = "Ubuntu 20.04"
      + key_pair            = "myMainKeypair"
      + name                = "bastion"
      + power_state         = "active"
      + region              = "GRA7"
      + security_groups     = [
          + "default",
        ]
      + stop_before_destroy = false
      + updated             = (known after apply)

      + network {
          + access_network = false
          + fixed_ip_v4    = (known after apply)
          + fixed_ip_v6    = (known after apply)
          + floating_ip    = (known after apply)
          + mac            = (known after apply)
          + name           = "myNetwork"
          + port           = (known after apply)
          + uuid           = (known after apply)
        }
    }

  # module.floatip.openstack_compute_floatingip_associate_v2.floatip_association will be created
  + resource "openstack_compute_floatingip_associate_v2" "floatip_association" {
      + floating_ip = (known after apply)
      + id          = (known after apply)
      + instance_id = (known after apply)
      + region      = "GRA7"
    }

  # module.floatip.openstack_networking_floatingip_v2.floatip will be created
  + resource "openstack_networking_floatingip_v2" "floatip" {
      + address    = (known after apply)
      + all_tags   = (known after apply)
      + dns_domain = (known after apply)
      + dns_name   = (known after apply)
      + fixed_ip   = (known after apply)
      + id         = (known after apply)
      + pool       = "Ext-Net"
      + port_id    = (known after apply)
      + region     = "GRA7"
      + subnet_id  = (known after apply)
      + tenant_id  = (known after apply)
    }

  # module.keypair.local_file.ssh_private_key will be created
  + resource "local_file" "ssh_private_key" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "./myMainKeypair_rsa"
      + id                   = (known after apply)
    }

  # module.keypair.local_file.ssh_public_key will be created
  + resource "local_file" "ssh_public_key" {
      + content              = (known after apply)
      + directory_permission = "0777"
      + file_permission      = "0600"
      + filename             = "./myMainKeypair_rsa.pub"
      + id                   = (known after apply)
    }

  # module.keypair.openstack_compute_keypair_v2.main_keypair will be created
  + resource "openstack_compute_keypair_v2" "main_keypair" {
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + name        = "myMainKeypair"
      + private_key = (known after apply)
      + public_key  = (known after apply)
      + region      = "GRA7"
      + user_id     = (known after apply)
    }

  # module.network.openstack_networking_network_v2.my_private_network will be created
  + resource "openstack_networking_network_v2" "my_private_network" {
      + admin_state_up          = true
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + dns_domain              = (known after apply)
      + external                = (known after apply)
      + id                      = (known after apply)
      + mtu                     = (known after apply)
      + name                    = "myNetwork"
      + port_security_enabled   = (known after apply)
      + qos_policy_id           = (known after apply)
      + region                  = "GRA7"
      + shared                  = (known after apply)
      + tenant_id               = (known after apply)
      + transparent_vlan        = (known after apply)
    }

  # module.network.openstack_networking_router_interface_v2.my_router_interface will be created
  + resource "openstack_networking_router_interface_v2" "my_router_interface" {
      + id        = (known after apply)
      + port_id   = (known after apply)
      + region    = "GRA7"
      + router_id = (known after apply)
      + subnet_id = (known after apply)
    }

  # module.network.openstack_networking_router_v2.my_router will be created
  + resource "openstack_networking_router_v2" "my_router" {
      + admin_state_up          = true
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + distributed             = (known after apply)
      + enable_snat             = (known after apply)
      + external_gateway        = (known after apply)
      + external_network_id     = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx"
      + id                      = (known after apply)
      + name                    = "myRouter"
      + region                  = "GRA7"
      + tenant_id               = (known after apply)

      + external_fixed_ip {
          + ip_address = (known after apply)
          + subnet_id  = (known after apply)
        }
    }

  # module.network.openstack_networking_subnet_v2.my_subnet will be created
  + resource "openstack_networking_subnet_v2" "my_subnet" {
      + all_tags          = (known after apply)
      + cidr              = "192.168.12.0/24"
      + dns_nameservers   = [
          + "1.1.1.1",
          + "1.0.0.1",
        ]
      + enable_dhcp       = true
      + gateway_ip        = (known after apply)
      + id                = (known after apply)
      + ip_version        = 4
      + ipv6_address_mode = (known after apply)
      + ipv6_ra_mode      = (known after apply)
      + name              = "mySubnet"
      + network_id        = (known after apply)
      + no_gateway        = false
      + region            = "GRA7"
      + service_types     = (known after apply)
      + tenant_id         = (known after apply)

      + allocation_pool {
          + end   = "192.168.12.254"
          + start = "192.168.12.100"
        }

      + allocation_pools {
          + end   = (known after apply)
          + start = (known after apply)
        }
    }

Plan: 10 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bastion_floating_ip = (known after apply)
  + bastion_private_ip  = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

module.keypair.openstack_compute_keypair_v2.main_keypair: Creating...
module.network.openstack_networking_router_v2.my_router: Creating...
module.network.openstack_networking_network_v2.my_private_network: Creating...
module.keypair.openstack_compute_keypair_v2.main_keypair: Creation complete after 1s [id=myMainKeypair]
module.keypair.local_file.ssh_private_key: Creating...
module.keypair.local_file.ssh_public_key: Creating...
module.keypair.local_file.ssh_public_key: Creation complete after 0s [id=xxxxxxxx78cdd17096b452a57b4be3d4xxxxxxxx]
module.keypair.local_file.ssh_private_key: Creation complete after 0s [id=xxxxxxxxec60f1d63524a60200bbc7c7xxxxxxxx]
module.network.openstack_networking_network_v2.my_private_network: Creation complete after 6s [id=xxxxxxxx-c36d-4d36-8437-xxxxxxxxxxxxx]
module.network.openstack_networking_subnet_v2.my_subnet: Creating...
module.network.openstack_networking_router_v2.my_router: Still creating... [10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Creation complete after 7s [id=xxxxxxxx-2d05-4884-a7ed-xxxxxxxxxxxx]
module.network.openstack_networking_router_v2.my_router: Still creating... [20s elapsed]
module.network.openstack_networking_router_v2.my_router: Creation complete after 21s [id=xxxxxxxx-ddb1-4bf8-b5ac-xxxxxxxxxxxx]
module.network.openstack_networking_router_interface_v2.my_router_interface: Creating...
module.network.openstack_networking_router_interface_v2.my_router_interface: Creation complete after 9s [id=xxxxxxxx-f390-48fb-9935-xxxxxxxxxxxx]
module.bastion.openstack_compute_instance_v2.simple_instance: Creating...
module.bastion.openstack_compute_instance_v2.simple_instance: Still creating... [10s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Still creating... [20s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Still creating... [30s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Still creating... [40s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Still creating... [50s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Still creating... [1m0s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Creation complete after 1m6s [id=xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx]
module.floatip.openstack_networking_floatingip_v2.floatip: Creating...
module.floatip.openstack_networking_floatingip_v2.floatip: Still creating... [10s elapsed]
module.floatip.openstack_networking_floatingip_v2.floatip: Creation complete after 14s [id=xxxxxxxx-7b35-49bc-aa89-xxxxxxxxxxxx]
module.floatip.openstack_compute_floatingip_associate_v2.floatip_association: Creating...
module.floatip.openstack_compute_floatingip_associate_v2.floatip_association: Creation complete after 6s [id=51.xx.xx.xx/xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx/]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.

Outputs:

bastion_floating_ip = "51.xx.xx.xx"
bastion_private_ip = "192.168.12.184"
```

</details>

Note the last lines, that are generated by the terraform output:

```log
bastion_floating_ip = "51.xx.xx.xx"
bastion_private_ip = "192.168.12.184"
```

- bastion_floating_ip: The public IP address to access the bastion instance.

- bastion_private_ip: The private IP address of the bastion instance.

## Usage and test

Connect to the `bastion` instance via SSH. 

Use the created SSH keypair file and the IP address given by the `bastion_private_ip` value:

```bash
ssh -i myMainKeypair_rsa ubuntu@51.xx.xx.xx
```

When asked for continuing, answer yes:

```bash
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

You should have the bastion prompt:

```bash
ubuntu@bastion:~$
```

Congrats! You've reached the end of this tutorial.

## Destroy

To destroy and remove everything, use the terraform destroy command: 

```bash
terraform destroy -var-file=variables.tfvars
```

<details><summary> 📍 Output (click to expand)</summary>

```log
$ terraform destroy -var-file=variables.tfvars
module.network.data.openstack_networking_network_v2.ext_net: Reading...
module.keypair.openstack_compute_keypair_v2.main_keypair: Refreshing state... [id=myMainKeypair]
module.network.openstack_networking_network_v2.my_private_network: Refreshing state... [id=xxxxxxxx-c36d-4d36-8437-xxxxxxxxxxxxx]
module.network.openstack_networking_subnet_v2.my_subnet: Refreshing state... [id=xxxxxxxx-2d05-4884-a7ed-xxxxxxxxxxxx]
module.keypair.local_file.ssh_public_key: Refreshing state... [id=xxxxxxxx78cdd17096b452a57b4be3d4xxxxxxxx]
module.keypair.local_file.ssh_private_key: Refreshing state... [id=xxxxxxxxec60f1d63524a60200bbc7c7xxxxxxxx]
module.network.data.openstack_networking_network_v2.ext_net: Read complete after 2s [id=xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx]
module.network.openstack_networking_router_v2.my_router: Refreshing state... [id=xxxxxxxx-ddb1-4bf8-b5ac-xxxxxxxxxxxx]
module.network.openstack_networking_router_interface_v2.my_router_interface: Refreshing state... [id=xxxxxxxx-f390-48fb-9935-xxxxxxxxxxxx]
module.bastion.openstack_compute_instance_v2.simple_instance: Refreshing state... [id=xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx]
module.floatip.openstack_networking_floatingip_v2.floatip: Refreshing state... [id=xxxxxxxx-7b35-49bc-aa89-xxxxxxxxxxxx]
module.floatip.openstack_compute_floatingip_associate_v2.floatip_association: Refreshing state... [id=51.xx.xx.xx/xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx/]

Terraform used the selected providers to generate the following execution plan. Resource actions are
indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # module.bastion.openstack_compute_instance_v2.simple_instance will be destroyed
  - resource "openstack_compute_instance_v2" "simple_instance" {
      - access_ip_v4        = "192.168.12.184" -> null
      - all_metadata        = {} -> null
      - all_tags            = [] -> null
      - availability_zone   = "nova" -> null
      - created             = "2023-01-04 10:39:05 +0000 UTC" -> null
      - flavor_id           = "0da61e94-ce69-4971-b6df-c410fa3659ec" -> null
      - flavor_name         = "b2-7" -> null
      - force_delete        = false -> null
      - id                  = "xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx" -> null
      - image_id            = "ff40b983-fb54-40f7-8289-fe522ebdffb7" -> null
      - image_name          = "Ubuntu 20.04" -> null
      - key_pair            = "myMainKeypair" -> null
      - name                = "bastion" -> null
      - power_state         = "active" -> null
      - region              = "GRA7" -> null
      - security_groups     = [
          - "default",
        ] -> null
      - stop_before_destroy = false -> null
      - tags                = [] -> null
      - updated             = "2023-01-04 10:40:07 +0000 UTC" -> null

      - network {
          - access_network = false -> null
          - fixed_ip_v4    = "192.168.12.184" -> null
          - mac            = "fa:16:3e:a4:a9:91" -> null
          - name           = "myNetwork" -> null
          - uuid           = "xxxxxxxx-c36d-4d36-8437-xxxxxxxxxxxxx" -> null
        }
    }

  # module.floatip.openstack_compute_floatingip_associate_v2.floatip_association will be destroyed
  - resource "openstack_compute_floatingip_associate_v2" "floatip_association" {
      - floating_ip = "51.xx.xx.xx" -> null
      - id          = "51.xx.xx.xx/xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx/" -> null
      - instance_id = "xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx" -> null
      - region      = "GRA7" -> null
    }

  # module.floatip.openstack_networking_floatingip_v2.floatip will be destroyed
  - resource "openstack_networking_floatingip_v2" "floatip" {
      - address   = "51.xx.xx.xx" -> null
      - all_tags  = [] -> null
      - fixed_ip  = "192.168.12.184" -> null
      - id        = "xxxxxxxx-7b35-49bc-aa89-xxxxxxxxxxxx" -> null
      - pool      = "Ext-Net" -> null
      - port_id   = "89af31b0-6f02-400c-acf6-a5cb34d5973b" -> null
      - region    = "GRA7" -> null
      - tags      = [] -> null
      - tenant_id = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
    }

  # module.keypair.local_file.ssh_private_key will be destroyed
  - resource "local_file" "ssh_private_key" {
      - content              = <<-EOT
            -----BEGIN RSA PRIVATE KEY-----
            MIIEpAIBAAKCAQEAoZISw6wsZchRWsFxW/sTSLWuODLKk9H+E9KWdE/TzQPExXIK
            tTLIH3ue+jQmATNjvqoc+j/kg53xt/BeadwsP3vV+tosPhWh4VAX4KOKyL2vWQit
            ...
            ...
            vTHYiU4gHwuQjOFyS6I0LZsEsol2JkWwCXGRCgc/6HT5L5mmLlWPVjegA7u4OPMY
            clzxwIOhaduveouWmZ/wVtAawqcrCF9ya4RTX7sYvZqV6SUcqruT8Q==
            -----END RSA PRIVATE KEY-----
        EOT -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0600" -> null
      - filename             = "./myMainKeypair_rsa" -> null
      - id                   = "xxxxxxxxec60f1d63524a60200bbc7c7xxxxxxxx" -> null
    }

  # module.keypair.local_file.ssh_public_key will be destroyed
  - resource "local_file" "ssh_public_key" {
      - content              = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChkhLDrCxlyFFawXFb+xNIta44MsqT0f4T0pZ0T9PNA8TFcgq1Msgfe576NCYBM2O+qhz6P+SDnfG38F5p3Cw/e9X62iw+FaHhUBfgo4rIva9ZCK0btcQSMHt+P32uPzSLKF6vWbZ+ZmMG1p5NAVokzCw1l0rfDgBl5OW+r7dBGcSOqpEB/Zo5opLFMMjTlWA5p0awXKZAbTXU3XbwqVPuFVr8ZX8DTV+gpY0ubfdU3Nm3rgBQXy7+sT+beCcHYp4D+PjbRVum9FWgBi6IXhfD6/h8SE0UlEo9ndKMoFoSYUoy2ianIgMxJxEpxZBmOF41vQ/amLboCygP6E3ORMDV Generated-by-Nova" -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0600" -> null
      - filename             = "./myMainKeypair_rsa.pub" -> null
      - id                   = "xxxxxxxx78cdd17096b452a57b4be3d4xxxxxxxx" -> null
    }

  # module.keypair.openstack_compute_keypair_v2.main_keypair will be destroyed
  - resource "openstack_compute_keypair_v2" "main_keypair" {
      - fingerprint = "8a:d7:5c:1c:e6:6c:d6:99:85:00:b7:7e:da:20:e7:34" -> null
      - id          = "myMainKeypair" -> null
      - name        = "myMainKeypair" -> null
      - private_key = <<-EOT
            -----BEGIN RSA PRIVATE KEY-----
            MIIEpAIBAAKCAQEAoZISw6wsZchRWsFxW/sTSLWuODLKk9H+E9KWdE/TzQPExXIK
            tTLIH3ue+jQmATNjvqoc+j/kg53xt/BeadwsP3vV+tosPhWh4VAX4KOKyL2vWQit
            ...
            ...
            vTHYiU4gHwuQjOFyS6I0LZsEsol2JkWwCXGRCgc/6HT5L5mmLlWPVjegA7u4OPMY
            clzxwIOhaduveouWmZ/wVtAawqcrCF9ya4RTX7sYvZqV6SUcqruT8Q==
            -----END RSA PRIVATE KEY-----
        EOT -> null
      - public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChkhLDrCxlyFFawXFb+xNIta44MsqT0f4T0pZ0T9PNA8TFcgq1Msgfe576NCYBM2O+qhz6P+SDnfG38F5p3Cw/e9X62iw+FaHhUBfgo4rIva9ZCK0btcQSMHt+P32uPzSLKF6vWbZ+ZmMG1p5NAVokzCw1l0rfDgBl5OW+r7dBGcSOqpEB/Zo5opLFMMjTlWA5p0awXKZAbTXU3XbwqVPuFVr8ZX8DTV+gpY0ubfdU3Nm3rgBQXy7+sT+beCcHYp4D+PjbRVum9FWgBi6IXhfD6/h8SE0UlEo9ndKMoFoSYUoy2ianIgMxJxEpxZBmOF41vQ/amLboCygP6E3ORMDV Generated-by-Nova" -> null
      - region      = "GRA7" -> null
    }

  # module.network.openstack_networking_network_v2.my_private_network will be destroyed
  - resource "openstack_networking_network_v2" "my_private_network" {
      - admin_state_up          = true -> null
      - all_tags                = [] -> null
      - availability_zone_hints = [] -> null
      - external                = false -> null
      - id                      = "xxxxxxxx-c36d-4d36-8437-xxxxxxxxxxxxx" -> null
      - mtu                     = 9000 -> null
      - name                    = "myNetwork" -> null
      - port_security_enabled   = true -> null
      - region                  = "GRA7" -> null
      - shared                  = false -> null
      - tags                    = [] -> null
      - tenant_id               = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - transparent_vlan        = false -> null
    }

  # module.network.openstack_networking_router_interface_v2.my_router_interface will be destroyed
  - resource "openstack_networking_router_interface_v2" "my_router_interface" {
      - id        = "xxxxxxxx-f390-48fb-9935-xxxxxxxxxxxx" -> null
      - port_id   = "xxxxxxxx-f390-48fb-9935-xxxxxxxxxxxx" -> null
      - region    = "GRA7" -> null
      - router_id = "xxxxxxxx-ddb1-4bf8-b5ac-xxxxxxxxxxxx" -> null
      - subnet_id = "xxxxxxxx-2d05-4884-a7ed-xxxxxxxxxxxx" -> null
    }

  # module.network.openstack_networking_router_v2.my_router will be destroyed
  - resource "openstack_networking_router_v2" "my_router" {
      - admin_state_up          = true -> null
      - all_tags                = [] -> null
      - availability_zone_hints = [] -> null
      - distributed             = false -> null
      - enable_snat             = true -> null
      - external_gateway        = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx" -> null
      - external_network_id     = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxxxxxx" -> null
      - id                      = "xxxxxxxx-ddb1-4bf8-b5ac-xxxxxxxxxxxx" -> null
      - name                    = "myRouter" -> null
      - region                  = "GRA7" -> null
      - tags                    = [] -> null
      - tenant_id               = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null

      - external_fixed_ip {
          - ip_address = "51.yy.yy.yy" -> null
          - subnet_id  = "xxxxxxxx-3b39-489e-b088-xxxxxxxxxxxx" -> null
        }
    }

  # module.network.openstack_networking_subnet_v2.my_subnet will be destroyed
  - resource "openstack_networking_subnet_v2" "my_subnet" {
      - all_tags        = [] -> null
      - cidr            = "192.168.12.0/24" -> null
      - dns_nameservers = [
          - "1.1.1.1",
          - "1.0.0.1",
        ] -> null
      - enable_dhcp     = true -> null
      - gateway_ip      = "192.168.12.1" -> null
      - id              = "xxxxxxxx-2d05-4884-a7ed-xxxxxxxxxxxx" -> null
      - ip_version      = 4 -> null
      - name            = "mySubnet" -> null
      - network_id      = "xxxxxxxx-c36d-4d36-8437-xxxxxxxxxxxxx" -> null
      - no_gateway      = false -> null
      - region          = "GRA7" -> null
      - service_types   = [] -> null
      - tags            = [] -> null
      - tenant_id       = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null

      - allocation_pool {
          - end   = "192.168.12.254" -> null
          - start = "192.168.12.100" -> null
        }

      - allocation_pools {
          - end   = "192.168.12.254" -> null
          - start = "192.168.12.100" -> null
        }
    }

Plan: 0 to add, 0 to change, 10 to destroy.

Changes to Outputs:
  - bastion_floating_ip = "51.xx.xx.xx" -> null
  - bastion_private_ip  = "192.168.12.184" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.floatip.openstack_compute_floatingip_associate_v2.floatip_association: Destroying... [id=51.xx.xx.xx/xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx/]
module.floatip.openstack_compute_floatingip_associate_v2.floatip_association: Destruction complete after 5s
module.floatip.openstack_networking_floatingip_v2.floatip: Destroying... [id=xxxxxxxx-7b35-49bc-aa89-xxxxxxxxxxxx]
module.floatip.openstack_networking_floatingip_v2.floatip: Destruction complete after 7s
module.bastion.openstack_compute_instance_v2.simple_instance: Destroying... [id=xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx]
module.bastion.openstack_compute_instance_v2.simple_instance: Still destroying... [id=xxxxxxxx-3cc2-4baf-a69a-xxxxxxxxxxxx, 10s elapsed]
module.bastion.openstack_compute_instance_v2.simple_instance: Destruction complete after 10s
module.network.openstack_networking_router_interface_v2.my_router_interface: Destroying... [id=xxxxxxxx-f390-48fb-9935-xxxxxxxxxxxx]
module.keypair.local_file.ssh_private_key: Destroying... [id=xxxxxxxxec60f1d63524a60200bbc7c7xxxxxxxx]
module.keypair.local_file.ssh_public_key: Destroying... [id=xxxxxxxx78cdd17096b452a57b4be3d4xxxxxxxx]
module.keypair.local_file.ssh_private_key: Destruction complete after 0s
module.keypair.local_file.ssh_public_key: Destruction complete after 0s
module.keypair.openstack_compute_keypair_v2.main_keypair: Destroying... [id=myMainKeypair]
module.keypair.openstack_compute_keypair_v2.main_keypair: Destruction complete after 0s
module.network.openstack_networking_router_interface_v2.my_router_interface: Still destroying... [id=xxxxxxxx-f390-48fb-9935-xxxxxxxxxxxx, 10s elapsed]
module.network.openstack_networking_router_interface_v2.my_router_interface: Destruction complete after 15s
module.network.openstack_networking_router_v2.my_router: Destroying... [id=xxxxxxxx-ddb1-4bf8-b5ac-xxxxxxxxxxxx]
module.network.openstack_networking_subnet_v2.my_subnet: Destroying... [id=xxxxxxxx-2d05-4884-a7ed-xxxxxxxxxxxx]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-2d05-4884-a7ed-xxxxxxxxxxxx, 10s elapsed]
module.network.openstack_networking_router_v2.my_router: Still destroying... [id=xxxxxxxx-ddb1-4bf8-b5ac-xxxxxxxxxxxx, 10s elapsed]
module.network.openstack_networking_router_v2.my_router: Destruction complete after 10s
module.network.openstack_networking_subnet_v2.my_subnet: Destruction complete after 10s
module.network.openstack_networking_network_v2.my_private_network: Destroying... [id=xxxxxxxx-c36d-4d36-8437-xxxxxxxxxxxxx]
module.network.openstack_networking_network_v2.my_private_network: Destruction complete after 6s

Destroy complete! Resources: 10 destroyed.
```

</details>
