# Managed MongoDb database with private network

This example builds a Managed MongoDb database connected to a private network within OVHcloud Public Cloud.

The components that will be created are : 

- A [Managed MongoDb database](https://www.ovhcloud.com/en/public-cloud/mongodb)

![Managed MongoDb](./img/img01.png)

## Pre-requisites

You need to follow steps from the [basics tutorial](../../basics/README.md) for having necessary tools and a fonctionnal `ovhrc` file.

You need to have a functional routed private network. If not read and apply the [Simple private network](../../networking/private-network-mono-region/README.md) tutorial.

## properties files

This is the parameters needed by the scripts:

![Managed MongoDb](./img/img02.png)

Edit the `variables.tf` file to modify values:

```terraform

```

## Create

Create the MongoDb database with this commands:

```bash
source ovhrc
terraform init
terraform plan
terraform apply
```

Or simply use the `createDb.sh` script.

```bash
./createDb.sh
```

<details><summary>See output</summary>

```bash
data.openstack_networking_network_v2.myPrivateNetwork: Reading...
data.openstack_networking_subnet_v2.mySubnet: Reading...
data.openstack_networking_subnet_v2.mySubnet: Read complete after 1s [id=ab6524c3-78ac-4a1b-af85-b8d45b9c7cfe]
data.openstack_networking_network_v2.myPrivateNetwork: Read complete after 1s [id=4262cd8e-d430-4c31-8e2d-efa4d353fc5b]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # ovh_cloud_project_database.mongodb will be created
  + resource "ovh_cloud_project_database" "mongodb" {
      + backup_time      = (known after apply)
      + created_at       = (known after apply)
      + description      = "myMongoDb"
      + disk_type        = (known after apply)
      + endpoints        = (known after apply)
      + engine           = "mongodb"
      + flavor           = "db1-2"
      + id               = (known after apply)
      + maintenance_time = (known after apply)
      + network_type     = (known after apply)
      + plan             = "business"
      + service_name     = "706b47d91da24017a6a6f6b6ef1cf53a"
      + status           = (known after apply)
      + version          = "6.0"

      + nodes {
          + network_id = "4262cd8e-d430-4c31-8e2d-efa4d353fc5b"
          + region     = "GRA"
          + subnet_id  = "ab6524c3-78ac-4a1b-af85-b8d45b9c7cfe"
        }
      + nodes {
          + network_id = "4262cd8e-d430-4c31-8e2d-efa4d353fc5b"
          + region     = "GRA"
          + subnet_id  = "ab6524c3-78ac-4a1b-af85-b8d45b9c7cfe"
        }
      + nodes {
          + network_id = "4262cd8e-d430-4c31-8e2d-efa4d353fc5b"
          + region     = "GRA"
          + subnet_id  = "ab6524c3-78ac-4a1b-af85-b8d45b9c7cfe"
        }
    }

  # ovh_cloud_project_database_ip_restriction.iprestriction will be created
  + resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      + cluster_id   = (known after apply)
      + engine       = "mongodb"
      + id           = (known after apply)
      + ip           = "192.168.2.0/24"
      + service_name = "706b47d91da24017a6a6f6b6ef1cf53a"
      + status       = (known after apply)
    }

  # ovh_cloud_project_database_mongodb_user.mongouser will be created
  + resource "ovh_cloud_project_database_mongodb_user" "mongouser" {
      + cluster_id     = (known after apply)
      + created_at     = (known after apply)
      + id             = (known after apply)
      + name           = "myuser@admin"
      + password       = (sensitive value)
      + password_reset = "changeMeToResetPassword"
      + roles          = [
          + "dbAdminAnyDatabase",
        ]
      + service_name   = "706b47d91da24017a6a6f6b6ef1cf53a"
      + status         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + dbId           = (known after apply)
  + dbUserPassword = (sensitive value)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

ovh_cloud_project_database.mongodb: Creating...
ovh_cloud_project_database.mongodb: Still creating... [10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [1m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [1m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [1m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [1m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [1m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [1m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [2m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [2m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [2m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [2m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [2m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [2m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [3m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [3m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [3m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [3m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [3m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [3m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [4m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [4m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [4m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [4m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [4m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [4m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [5m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [5m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [5m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [5m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [5m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [5m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [6m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [6m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [6m20s elapsed]
ovh_cloud_project_database.mongodb: Creation complete after 6m22s [id=9e1634e6-f470-4522-a1b8-4662fc4aa725]
ovh_cloud_project_database_ip_restriction.iprestriction: Creating...
ovh_cloud_project_database_mongodb_user.mongouser: Creating...
ovh_cloud_project_database_mongodb_user.mongouser: Still creating... [10s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [10s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still creating... [20s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [20s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Creation complete after 21s [id=42b7019a-96cb-4f7e-9019-980deacf56c0]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [30s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [40s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [50s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [1m0s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [1m10s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Creation complete after 1m17s [id=1174843146]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

dbId = "9e1634e6-f470-4522-a1b8-4662fc4aa725"
dbUserPassword = <sensitive>
serviceName = "706b47d91da24017a6a6f6b6ef1cf53a"
```

</details>

## Get current user password

```bash
terraform output dbUserPassword
```

## Reset current user password

Open and edit the `resources.tf` file and change the value of the `password_reset` parameter, from the `ovh_cloud_project_database_mongodb_user` resource block.

Then, re-apply the plan to perform a password resseti and get the new one with:

```bash
terraform apply
terraform output dbUserPassword
```

## Delete / Purge

Clean you environment with this commands:

```bash
source ovhrc
terraform destroy --auto-approve
```

Or execute the `deleteDb.sh` script:

```bash
./deleteDb.sh
```

<details><summary>See output</summary>

```bash

```

</details>


