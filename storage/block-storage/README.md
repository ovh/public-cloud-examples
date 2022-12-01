# Simple volume

This example builds a block storage volume within OVHcloud Public Cloud.

The components that will be created are : 

- [Block Storage Volume](https://www.ovhcloud.com/fr/public-cloud/block-storage).

## Pre-requisites

You need to follow steps from the [basics tutorial](../../basics/README.md) for having necessary tools and a fonctionnal `ovhrc` file.

## properties files

Edit the `variables.auto.tfvars` file to modify values:

```terraform
// Region

region = "GRA7"

// Block Storage Volume

bsName = "my-block-storage-volume"
bsSize = 100
```

## Create

Create the volume with this commands:

```bash
source ovhrc
terraform init
terraform plan
terraform apply
```

Or simply use the `createVolume.sh` script.

```bash
./createVolume.sh
```

<details><summary>See output</summary>

```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # openstack_blockstorage_volume_v3.bsVolume will be created
  + resource "openstack_blockstorage_volume_v3" "bsVolume" {
      + attachment        = (known after apply)
      + availability_zone = (known after apply)
      + id                = (known after apply)
      + metadata          = (known after apply)
      + name              = "my-block-storage-volume"
      + region            = "GRA7"
      + size              = 100
      + volume_type       = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + serviceName = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
  + volumeId    = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

openstack_blockstorage_volume_v3.bsVolume: Creating...
openstack_blockstorage_volume_v3.bsVolume: Still creating... [10s elapsed]
openstack_blockstorage_volume_v3.bsVolume: Creation complete after 12s [id=xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

serviceName = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
volumeId = "xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx"
```

</details>

## Delete / Purge

Clean you environment with this commands:

```bash
source ovhrc
terraform destroy --auto-approve
```

Or execute the `deleteVolume.sh` script:

```bash
./deleteVolume.sh
```

<details><summary>See output</summary>

```bash
openstack_blockstorage_volume_v3.bsVolume: Refreshing state... [id=xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # openstack_blockstorage_volume_v3.bsVolume will be destroyed
  - resource "openstack_blockstorage_volume_v3" "bsVolume" {
      - attachment        = [] -> null
      - availability_zone = "nova" -> null
      - id                = "xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx" -> null
      - metadata          = {} -> null
      - name              = "my-block-storage-volume" -> null
      - region            = "GRA7" -> null
      - size              = 100 -> null
      - volume_type       = "classic" -> null
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  - serviceName = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
  - volumeId    = "xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx" -> null
openstack_blockstorage_volume_v3.bsVolume: Destroying... [id=xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx]
openstack_blockstorage_volume_v3.bsVolume: Still destroying... [id=xxxxxxxx-764e-450e-b29f-xxxxxxxxxxxx, 10s elapsed]
openstack_blockstorage_volume_v3.bsVolume: Destruction complete after 15s

Destroy complete! Resources: 1 destroyed.
```

</details>


