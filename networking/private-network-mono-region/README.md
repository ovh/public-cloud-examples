# Simple private network

vRack + private network + subnet + router

## Pre-requisites

examples - basics - ovhrc file

## properties files

```bash
# Region
export TF_VAR_region="${OS_REGION_NAME}"

# Network - Private Network
export TF_VAR_pvNetworkName="myPrivateNetwork"
export TF_VAR_pvNetworkId="30"

# Network - Subnet
export TF_VAR_subnetName="mySubnet"
export TF_VAR_subnetCIDR="192.168.2.0/24"
export TF_VAR_subnetDHCPStart="192.168.2.200"
export TF_VAR_subnetDHCPEnd="192.168.2.254"

# Network - Router
export TF_VAR_rtrName="myRouter"
export TF_VAR_rtrIp="192.168.2.1"
```

## createNetwork.sh

```bash
./createNetwork.sh
```

<details><summary>See result</summary>

```bash
Initializing the backend...

Initializing provider plugins...
- Finding terraform-provider-openstack/openstack versions matching "~> 1.35.0"...
- Finding latest version of ovh/ovh...
- Installing terraform-provider-openstack/openstack v1.35.0...
- Installed terraform-provider-openstack/openstack v1.35.0 (self-signed, key ID 4F80527A391BEFD2)
- Installing ovh/ovh v0.22.0...
- Installed ovh/ovh v0.22.0 (signed by a HashiCorp partner, key ID F56D1A6CBDAAADA5)

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
openstack_networking_network_v2.Ext-Net: Importing from ID "xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx"...
openstack_networking_network_v2.Ext-Net: Import prepared!
  Prepared openstack_networking_network_v2 for import
openstack_networking_network_v2.Ext-Net: Refreshing state... [id=xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

openstack_networking_network_v2.Ext-Net: Refreshing state... [id=xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # openstack_networking_router_interface_v2.myRouterInterface will be created
  + resource "openstack_networking_router_interface_v2" "myRouterInterface" {
      + id        = (known after apply)
      + port_id   = (known after apply)
      + region    = (known after apply)
      + router_id = (known after apply)
      + subnet_id = (known after apply)
    }

  # openstack_networking_router_v2.myRouter will be created
  + resource "openstack_networking_router_v2" "myRouter" {
      + admin_state_up          = true
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + distributed             = (known after apply)
      + enable_snat             = (known after apply)
      + external_gateway        = (known after apply)
      + external_network_id     = "xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx"
      + id                      = (known after apply)
      + name                    = "myRouter"
      + region                  = (known after apply)
      + tenant_id               = (known after apply)

      + external_fixed_ip {
          + ip_address = (known after apply)
          + subnet_id  = (known after apply)
        }
    }

  # openstack_networking_subnet_v2.mySubnet will be created
  + resource "openstack_networking_subnet_v2" "mySubnet" {
      + all_tags          = (known after apply)
      + cidr              = "192.168.2.0/24"
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
      + region            = "GRA9"
      + tenant_id         = (known after apply)

      + allocation_pool {
          + end   = "192.168.2.254"
          + start = "192.168.2.200"
        }

      + allocation_pools {
          + end   = (known after apply)
          + start = (known after apply)
        }
    }

  # ovh_cloud_project_network_private.myPrivateNetwork will be created
  + resource "ovh_cloud_project_network_private" "myPrivateNetwork" {
      + id                 = (known after apply)
      + name               = "myPrivateNetwork"
      + regions            = [
          + "GRA9",
        ]
      + regions_attributes = (known after apply)
      + regions_status     = (known after apply)
      + service_name       = "xxxxxxxxxxxx4017a6a6f6bxxxxxxxxx"
      + status             = (known after apply)
      + type               = (known after apply)
      + vlan_id            = 30
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + myPrivateNetworkID = (known after apply)
  + mySubnetID         = (known after apply)

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
openstack_networking_network_v2.Ext-Net: Refreshing state... [id=xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # openstack_networking_router_interface_v2.myRouterInterface will be created
  + resource "openstack_networking_router_interface_v2" "myRouterInterface" {
      + id        = (known after apply)
      + port_id   = (known after apply)
      + region    = (known after apply)
      + router_id = (known after apply)
      + subnet_id = (known after apply)
    }

  # openstack_networking_router_v2.myRouter will be created
  + resource "openstack_networking_router_v2" "myRouter" {
      + admin_state_up          = true
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + distributed             = (known after apply)
      + enable_snat             = (known after apply)
      + external_gateway        = (known after apply)
      + external_network_id     = "xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx"
      + id                      = (known after apply)
      + name                    = "myRouter"
      + region                  = (known after apply)
      + tenant_id               = (known after apply)

      + external_fixed_ip {
          + ip_address = (known after apply)
          + subnet_id  = (known after apply)
        }
    }

  # openstack_networking_subnet_v2.mySubnet will be created
  + resource "openstack_networking_subnet_v2" "mySubnet" {
      + all_tags          = (known after apply)
      + cidr              = "192.168.2.0/24"
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
      + region            = "GRA9"
      + tenant_id         = (known after apply)

      + allocation_pool {
          + end   = "192.168.2.254"
          + start = "192.168.2.200"
        }

      + allocation_pools {
          + end   = (known after apply)
          + start = (known after apply)
        }
    }

  # ovh_cloud_project_network_private.myPrivateNetwork will be created
  + resource "ovh_cloud_project_network_private" "myPrivateNetwork" {
      + id                 = (known after apply)
      + name               = "myPrivateNetwork"
      + regions            = [
          + "GRA9",
        ]
      + regions_attributes = (known after apply)
      + regions_status     = (known after apply)
      + service_name       = "xxxxxxxxxxxx4017a6a6f6bxxxxxxxxx"
      + status             = (known after apply)
      + type               = (known after apply)
      + vlan_id            = 30
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + myPrivateNetworkID = (known after apply)
  + mySubnetID         = (known after apply)
openstack_networking_router_v2.myRouter: Creating...
ovh_cloud_project_network_private.myPrivateNetwork: Creating...
openstack_networking_router_v2.myRouter: Still creating... [10s elapsed]
ovh_cloud_project_network_private.myPrivateNetwork: Still creating... [10s elapsed]
ovh_cloud_project_network_private.myPrivateNetwork: Creation complete after 16s [id=pn-1083922_30]
openstack_networking_subnet_v2.mySubnet: Creating...
openstack_networking_router_v2.myRouter: Creation complete after 17s [id=xxxxxx-e0d3-4889-ae7e-xxxxxxxxxxxx]
openstack_networking_subnet_v2.mySubnet: Creation complete after 6s [id=xxxxxxxx-6a1d-4027-8ebe-xxxxxxxxxxxx]
openstack_networking_router_interface_v2.myRouterInterface: Creating...
openstack_networking_router_interface_v2.myRouterInterface: Still creating... [10s elapsed]
openstack_networking_router_interface_v2.myRouterInterface: Creation complete after 12s [id=xxxxxxxx-038e-4572-ad80-xxxxxxxxxxxx]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

Ext-NetID = "xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx"
myPrivateNetworkID = "xxxxxxxx-cc06-49f7-8966-xxxxxxxxxxxx"
mySubnetID = "xxxxxxxx-6a1d-4027-8ebe-xxxxxxxxxxxx"
serviceName = "xxxxxxxxxxxx4017a6a6f6bxxxxxxxxx"
```

</details>

## importNetworks.sh

```bash

```

```bash

```

## deleteNetwork.sh

```bash

```

```bash

```
