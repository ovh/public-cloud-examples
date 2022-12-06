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

Edit the `variables.auto.tfvars` file to modify values:

```terraform
// Region

region = "GRA7"

// Region for database

dbRegion = "GRA"

// Network - Private Network

pvNetworkName = "myPrivateNetwork"

// Network - Subnet

subnetName = "mySubnet"

// Database

dbDescription = "myMongoDb"
dbEngine = "mongodb"
dbVersion = "6.0"
dbPlan = "business"
dbFlavor = "db1-7"

// Database User

dbUserName = "myuser"
dbUserRole = ["readWriteAnyDatabase"]

// IP Restriction

dbAllowedIp = "192.168.2.0/24"
```

> Note: dbUserRole possible values are:
> 
>    "readAnyDatabase"
>    "readWriteAnyDatabase"
>    "userAdminAnyDatabase"
>    "dbAdminAnyDatabase"
>    "backup"
>    "restore"

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
Initializing the backend...

Initializing provider plugins...
- Finding latest version of ovh/ovh...
- Finding terraform-provider-openstack/openstack versions matching "~> 1.35.0"...
- Installing terraform-provider-openstack/openstack v1.35.0...
- Installed terraform-provider-openstack/openstack v1.35.0 (self-signed, key ID 4F80527A391BEFD2)
- Installing ovh/ovh v0.23.0...
- Installed ovh/ovh v0.23.0 (signed by a HashiCorp partner, key ID F56D1A6CBDAAADA5)

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
data.openstack_networking_subnet_v2.mySubnet: Reading...
data.openstack_networking_network_v2.myPrivateNetwork: Reading...
data.openstack_networking_network_v2.myPrivateNetwork: Read complete after 2s [id=xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx]
data.openstack_networking_subnet_v2.mySubnet: Read complete after 2s [id=xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx]

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
      + flavor           = "db1-7"
      + id               = (known after apply)
      + maintenance_time = (known after apply)
      + network_type     = (known after apply)
      + plan             = "business"
      + service_name     = "706b47d91da24017a6a6f6b6ef1cf53a"
      + status           = (known after apply)
      + version          = "6.0"

      + nodes {
          + network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx"
          + region     = "GRA"
          + subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx"
        }
      + nodes {
          + network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx"
          + region     = "GRA"
          + subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx"
        }
      + nodes {
          + network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx"
          + region     = "GRA"
          + subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx"
        }
    }

  # ovh_cloud_project_database_ip_restriction.iprestriction will be created
  + resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      + cluster_id   = (known after apply)
      + engine       = "mongodb"
      + id           = (known after apply)
      + ip           = "192.168.2.0/24"
      + service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
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
          + "readWriteAnyDatabase",
        ]
      + service_name   = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + dbId           = (known after apply)
  + dbUserPassword = (sensitive value)
  + serviceName    = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
data.openstack_networking_network_v2.myPrivateNetwork: Reading...
data.openstack_networking_subnet_v2.mySubnet: Reading...
data.openstack_networking_network_v2.myPrivateNetwork: Read complete after 1s [id=xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx]
data.openstack_networking_subnet_v2.mySubnet: Read complete after 2s [id=xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx]

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
      + flavor           = "db1-7"
      + id               = (known after apply)
      + maintenance_time = (known after apply)
      + network_type     = (known after apply)
      + plan             = "business"
      + service_name     = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status           = (known after apply)
      + version          = "6.0"

      + nodes {
          + network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx"
          + region     = "GRA"
          + subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx"
        }
      + nodes {
          + network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx"
          + region     = "GRA"
          + subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx"
        }
      + nodes {
          + network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx"
          + region     = "GRA"
          + subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx"
        }
    }

  # ovh_cloud_project_database_ip_restriction.iprestriction will be created
  + resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      + cluster_id   = (known after apply)
      + engine       = "mongodb"
      + id           = (known after apply)
      + ip           = "192.168.2.0/24"
      + service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
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
          + "readWriteAnyDatabase",
        ]
      + service_name   = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status         = (known after apply)
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + dbId           = (known after apply)
  + dbUserPassword = (sensitive value)
  + serviceName    = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
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
ovh_cloud_project_database.mongodb: Still creating... [6m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [6m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [6m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [7m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [7m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [7m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [7m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [7m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [7m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [8m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [8m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [8m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [8m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [8m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [8m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [9m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [9m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [9m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [9m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [9m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [9m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [10m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [10m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [10m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [10m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [10m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [10m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [11m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [11m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [11m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [11m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [11m40s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [11m50s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [12m0s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [12m10s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [12m20s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [12m30s elapsed]
ovh_cloud_project_database.mongodb: Still creating... [12m40s elapsed]
ovh_cloud_project_database.mongodb: Creation complete after 12m42s [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx]
ovh_cloud_project_database_ip_restriction.iprestriction: Creating...
ovh_cloud_project_database_mongodb_user.mongouser: Creating...
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [10s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still creating... [10s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [20s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still creating... [20s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Creation complete after 30s [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [30s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [40s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still creating... [50s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Creation complete after 50s [id=xxx4843xxx]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

dbId = "xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx"
dbUserPassword = <sensitive>
serviceName = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
```

</details>

## Get current user password

```bash
terraform output dbUserPassword
```

## Reset current user password

Open and edit the `resources.tf` file and change the value of the `password_reset` parameter, from the `ovh_cloud_project_database_mongodb_user` resource block.

Then, re-apply the plan to perform a password reset and get the new one with:

```bash
terraform apply
terraform output dbUserPassword
```

<details><summary>Output</summary>

```bash
data.openstack_networking_network_v2.myPrivateNetwork: Reading...
data.openstack_networking_subnet_v2.mySubnet: Reading...
data.openstack_networking_subnet_v2.mySubnet: Read complete after 2s [id=xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx]
data.openstack_networking_network_v2.myPrivateNetwork: Read complete after 2s [id=xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx]
ovh_cloud_project_database.mongodb: Refreshing state... [id=xxxxxxxx-e6b0-4253-abf4-xxxxxxxxxxxx]
ovh_cloud_project_database_ip_restriction.iprestriction: Refreshing state... [id=xxx4843xxx]
ovh_cloud_project_database_mongodb_user.mongouser: Refreshing state... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  ~ update in-place

Terraform will perform the following actions:

  # ovh_cloud_project_database_mongodb_user.mongouser will be updated in-place
  ~ resource "ovh_cloud_project_database_mongodb_user" "mongouser" {
        id             = "xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx"
        name           = "myuser@admin"
      ~ password_reset = "changeMeToResetPassword" -> "changeMeToResetPassword1"
        # (6 unchanged attributes hidden)
    }

Plan: 0 to add, 1 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

ovh_cloud_project_database_mongodb_user.mongouser: Modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx]
ovh_cloud_project_database_mongodb_user.mongouser: Still modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx, 10s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx, 20s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx, 30s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx, 40s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx, 50s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still modifying... [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx, 1m0s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Modifications complete after 1m9s [id=xxxxxxxx-f7be-4d0b-84f7-xxxxxxxxxxxx]

Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

dbId = "xxxxxxxx-e6b0-4253-abf4-xxxxxxxxxxxx"
dbUserPassword = <sensitive>
serviceName = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
```

</details>

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
data.openstack_networking_subnet_v2.mySubnet: Reading...
data.openstack_networking_network_v2.myPrivateNetwork: Reading...
data.openstack_networking_subnet_v2.mySubnet: Read complete after 1s [id=xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx]
data.openstack_networking_network_v2.myPrivateNetwork: Read complete after 2s [id=xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx]
ovh_cloud_project_database.mongodb: Refreshing state... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx]
ovh_cloud_project_database_ip_restriction.iprestriction: Refreshing state... [id=xxx4843xxx]
ovh_cloud_project_database_mongodb_user.mongouser: Refreshing state... [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # ovh_cloud_project_database.mongodb will be destroyed
  - resource "ovh_cloud_project_database" "mongodb" {
      - backup_time             = "00:00:00" -> null
      - created_at              = "2022-11-29T09:54:18.88983+01:00" -> null
      - description             = "myMongoDb" -> null
      - disk_size               = 50 -> null
      - disk_type               = "local-ssd" -> null
      - endpoints               = [
          - {
              - component = "mongodb"
              - domain    = "706b47d9xxxxxxxx.database.cloud.ovh.net"
              - path      = ""
              - port      = 27017
              - scheme    = "mongodb"
              - ssl       = true
              - ssl_mode  = "required"
              - uri       = "mongodb://<username>:<password>@node1-706b47d9xxxxxxxx.database.cloud.ovh.net,node2-706b47d9xxxxxxxx.database.cloud.ovh.net,node3-706b47d9xxxxxxxx.database.cloud.ovh.net/admin?replicaSet=replicaset&tls=true"
            },
          - {
              - component = "mongodbSrv"
              - domain    = "mongodb-xxxxxxxx-obf0d5312.database.cloud.ovh.net"
              - path      = ""
              - port      = 0
              - scheme    = "mongodb+srv"
              - ssl       = true
              - ssl_mode  = "required"
              - uri       = "mongodb+srv://<username>:<password>@mongodb-xxxxxxxx-obf0d5312.database.cloud.ovh.net/admin?replicaSet=replicaset&tls=true"
            },
        ] -> null
      - engine                  = "mongodb" -> null
      - flavor                  = "db1-7" -> null
      - id                      = "xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx" -> null
      - kafka_rest_api          = false -> null
      - maintenance_time        = "00:00:00" -> null
      - network_type            = "private" -> null
      - opensearch_acls_enabled = false -> null
      - plan                    = "business" -> null
      - service_name            = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status                  = "READY" -> null
      - version                 = "6.0" -> null

      - nodes {
          - network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx" -> null
          - region     = "GRA" -> null
          - subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx" -> null
        }
      - nodes {
          - network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx" -> null
          - region     = "GRA" -> null
          - subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx" -> null
        }
      - nodes {
          - network_id = "xxxxxxxx-d430-4c31-8e2d-xxxxxxxxxxxx" -> null
          - region     = "GRA" -> null
          - subnet_id  = "xxxxxxxx-78ac-4a1b-af85-xxxxxxxxxxxx" -> null
        }
    }

  # ovh_cloud_project_database_ip_restriction.iprestriction will be destroyed
  - resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      - cluster_id   = "xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx" -> null
      - engine       = "mongodb" -> null
      - id           = "xxx4843xxx" -> null
      - ip           = "192.168.2.0/24" -> null
      - service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status       = "READY" -> null
    }

  # ovh_cloud_project_database_mongodb_user.mongouser will be destroyed
  - resource "ovh_cloud_project_database_mongodb_user" "mongouser" {
      - cluster_id     = "xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx" -> null
      - created_at     = "2022-11-29T10:07:00.931398+01:00" -> null
      - id             = "xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx" -> null
      - name           = "myuser@admin" -> null
      - password       = (sensitive value)
      - password_reset = "changeMeToResetPassword" -> null
      - roles          = [
          - "readWriteAnyDatabase",
        ] -> null
      - service_name   = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status         = "READY" -> null
    }

Plan: 0 to add, 0 to change, 3 to destroy.

Changes to Outputs:
  - dbId           = "xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx" -> null
  - dbUserPassword = (sensitive value)
  - serviceName    = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
ovh_cloud_project_database_ip_restriction.iprestriction: Destroying... [id=xxx4843xxx]
ovh_cloud_project_database_mongodb_user.mongouser: Destroying... [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx]
ovh_cloud_project_database_mongodb_user.mongouser: Still destroying... [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx, 10s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Still destroying... [id=xxx4843xxx, 10s elapsed]
ovh_cloud_project_database_ip_restriction.iprestriction: Destruction complete after 10s
ovh_cloud_project_database_mongodb_user.mongouser: Still destroying... [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx, 20s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still destroying... [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx, 30s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Still destroying... [id=xxxxxxxx-c66b-42ad-965c-xxxxxxxxxxxx, 40s elapsed]
ovh_cloud_project_database_mongodb_user.mongouser: Destruction complete after 41s
ovh_cloud_project_database.mongodb: Destroying... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx]
ovh_cloud_project_database.mongodb: Still destroying... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx, 10s elapsed]
ovh_cloud_project_database.mongodb: Still destroying... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx, 20s elapsed]
ovh_cloud_project_database.mongodb: Still destroying... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx, 30s elapsed]
ovh_cloud_project_database.mongodb: Still destroying... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx, 40s elapsed]
ovh_cloud_project_database.mongodb: Still destroying... [id=xxxxxxxx-2df2-4006-a0f3-xxxxxxxxxxxx, 50s elapsed]
ovh_cloud_project_database.mongodb: Destruction complete after 51s

Destroy complete! Resources: 3 destroyed.
```

</details>


