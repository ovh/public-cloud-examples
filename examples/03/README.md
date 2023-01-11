# A Wordpress application deployed on a managed Kubernetes, connected to a managed MySQL database.

(Work in progress)

## Description

This example shows you how to deploy and access to a Wordpress application, installed on a managed Kubernetes Cluster that is connected to a managed MySQL database, and everything inside a private network, with [Terraform](https://www.terraform.io)

This example handle following resources:

- Private Network

- Subnet with DHCP range

- Virtual Router

- [Managed Kubernetes Cluster]()

- [Managed MySQL Database]()

![Example 03 schema](./img/03.png)

## Pre-requisites

Follow the [Starting Pack to manage your OVHcloud Services from shell](../../basics/README.md) tutorial to make your terraform client works with your [OVHcloud Public Cloud project](https://www.ovhcloud.com/en-gb/public-cloud).

## Variables

Create (or modify the existing one) a file `variables.tfvars` and add the following parts:

### Region part

```terraform
region = "GRA7"
```

- `region`: The region to deploy this example.

### Networking part

This variables are needed by the [private network module](../../modules/private_network)

#### Private Network

```terraform
network = {
  name = "myNetwork"
}
```

- `name`: The private network only needs a name to be configured

#### Subnet

```terraform
subnet = {
  name       = "mySubnet"
  cidr       = "192.168.12.0/24"
  dhcp_start = "192.168.12.100"
  dhcp_end   = "192.168.12.254"
}
```

- `name`: The subnet name.

- `cidr`: The subnet networking range, CIDR format.

- `dhcp_start`: The first IP address of the DHCP range.

- `dhcp_end`: The last IP address of the DHCP range.

#### Virtual Router

```terraform
router = {
  name = "myRouter"
}
```

- `name`: The virtual router only needs a name to be configured.

> Note: The router will be connected to the `Ext-Net` network associated to the given region, and to the private network. Its private IP address is automaticly the first of the subnet CIDR range.

### Managed Kubernetes part

This variables are needed by the [Managed Kubernetes with private network Module](../../modules/kubernetes/k8s_pvnw).

#### Kubernetes Master parameters

```terraform
kube = {
  name            = "mykubernetesCluster"
  pv_network_name = "myNetwork"
  gateway_ip      = "192.168.12.1"
}
```

- `name`: The name of your managed Kubernetes cluster.

- `pv_network_name`: The name of the private network, the same you gave on the networking part.

- `gateway_ip`: The router gateway IP address. The first IP address from the subnet range, as defined on the networking part.

#### Kubernetes Node Pool parameters

```terraform
pool = {
  name          = "mypool"
  flavor        = "b2-7"
  desired_nodes = "3"
  max_nodes     = "6"
  min_nodes     = "3"
}
```

- `name`: The instance pool name.

- `flavor`: The flavor type of the pool instances.

- `desired_nodes`: The desired number of nodes of the pool.

- `max_nodes`: The maximum number of nodes of the pool.

- `min_nodes`: The minimum number of nodes of the pool.

Note: If you have followed the [Starting Pack to manage your OVHcloud Services from shell](../../basics/README.md) tutorial, and have an openstack cli well configured, you can get the flavor list with this commands:

```bash
openstack --os-region-name=XXX flavor list
```

<details><summary> 📍 Click to see an example</summary>

```bash
$ openstack --os-region-name=GRA7 flavor list
+--------------------------------------+-----------------+--------+------+-----------+-------+-----------+
| ID                                   | Name            |    RAM | Disk | Ephemeral | VCPUs | Is Public |
+--------------------------------------+-----------------+--------+------+-----------+-------+-----------+
| 00671678-c4ce-4054-bbe9-c7fdac138847 | b2-30           |  30000 |  200 |         0 |     8 | True      |
| 0630f07f-ba2b-4983-b373-db402c9f0b20 | win-r2-120      | 120000 |  200 |         0 |     8 | True      |
| 0639c365-a5b5-42ea-8bfa-579aba08f5fc | win-r2-240-flex | 240000 |   50 |         0 |    16 | True      |
| 073ae75e-4146-4817-ba8a-17ebd979d4d2 | win-r2-15-flex  |  15000 |   50 |         0 |     2 | True      |
| 0996cda2-adda-4b5b-8ac9-fe1c14198e40 | win-r2-30       |  30000 |   50 |         0 |     2 | True      |
| 0da61e94-ce69-4971-b6df-c410fa3659ec | b2-7            |   7000 |   50 |         0 |     2 | True      |
| 10178fa6-e82b-4819-98b5-2d3532f43ecb | b2-7-flex       |   7000 |   50 |         0 |     2 | True      |
| 126053c8-7ace-4a3a-8182-79349752b0bf | c2-60           |  60000 |  400 |         0 |    16 | True      |
| 153f2660-8ba5-40f9-8477-fd36c22bd0dd | win-r2-240      | 240000 |  400 |         0 |    16 | True      |
| 188dcbc7-8cc2-4d31-bcd4-f154a900afc9 | r2-240          | 240000 |  400 |         0 |    16 | True      |
| 190103f8-6c6c-4a0e-82db-46799d8c1449 | win-c2-120      | 120000 |  400 |         0 |    32 | True      |
| 199060ac-6dde-435a-acab-78456ac337a7 | d2-4            |   4000 |   50 |         0 |     2 | True      |
| 20dec3c9-dec5-4de2-ae49-2ed5fa28f227 | win-r2-15       |  15000 |   50 |         0 |     2 | True      |
| 2130e8d7-0682-4a35-9f95-684b6eda6590 | b2-120-flex     | 120000 |   50 |         0 |    32 | True      |
| 213272d8-180d-4b5a-9b24-53a5863a3a0e | b2-30-flex      |  30000 |   50 |         0 |     8 | True      |
| 23ac7b50-fe38-463c-a30f-89ebb20f9683 | win-b2-60       |  60000 |  400 |         0 |    16 | True      |
| 257eb411-5cb8-4f7c-96b8-8d73837296ea | win-c2-15-flex  |  15000 |   50 |         0 |     4 | True      |
| 25e279cb-a9ee-4b21-bc13-65fb0a5e853f | c2-120-flex     | 120000 |   50 |         0 |    32 | True      |
| 2771688c-ee37-418d-8ff1-79825d390743 | win-t1-180      | 180000 |   50 |         0 |    36 | True      |
| 287e6c47-9482-4799-a70c-0b3f042dd10d | win-b2-120-flex | 120000 |   50 |         0 |    32 | True      |
| 29bfbf68-9249-485e-a407-7936de0125bc | win-c2-60       |  60000 |  400 |         0 |    16 | True      |
| 2f77f829-cb5e-4548-bac8-8cc4c6c737c6 | win-b2-15       |  15000 |  100 |         0 |     4 | True      |
| 30223b8d-0b3e-4a42-accb-ebc3f5b0194c | s1-2            |   2000 |   10 |         0 |     1 | True      |
| 30ad5745-5692-4562-bfa5-7ec0c869c89d | win-c2-60-flex  |  60000 |   50 |         0 |    16 | True      |
| 368568a5-573f-4a99-b7d5-f4b965009e88 | win-r2-60       |  60000 |  100 |         0 |     4 | True      |
| 39d5e6c5-9398-4004-b074-a3d0c7fc828a | r2-120          | 120000 |  200 |         0 |     8 | True      |
| 3b6da719-7602-4ec1-843e-aad85621aca6 | win-b2-60-flex  |  60000 |   50 |         0 |    16 | True      |
| 3ca3a4f7-17be-4f62-918a-fadb7f69eb26 | win-b2-7-flex   |   7000 |   50 |         0 |     2 | True      |
| 4b5244c4-fc2b-458d-96be-49001c0ea17c | c2-15-flex      |  15000 |   50 |         0 |     4 | True      |
| 50c40818-9495-492d-8965-e297b7f574a9 | win-c2-30-flex  |  30000 |   50 |         0 |     8 | True      |
| 57f70a63-d37e-4f7e-882a-912fe3a2ceb5 | win-r2-60-flex  |  60000 |   50 |         0 |     4 | True      |
| 585be8e5-0287-4310-8f62-7d16f3cbda3d | b2-60-flex      |  60000 |   50 |         0 |    16 | True      |
| 591b0b06-d005-48ee-9ab6-782a735feb48 | b2-60           |  60000 |  400 |         0 |    16 | True      |
| 5e238e8c-5057-4cbf-a673-060cc95b13ef | win-t2-90       |  90000 |  800 |         0 |    28 | True      |
| 65248c60-b2d1-4ed0-be5f-b86cdbbfb86a | win-c2-30       |  30000 |  200 |         0 |     8 | True      |
| 6a5f5b61-12ba-47cd-af89-0e1812364246 | r2-240-flex     | 240000 |   50 |         0 |    16 | True      |
| 6b4e9bfb-1f5e-495d-ab5f-8f946e2fa71f | c2-7-flex       |   7000 |   50 |         0 |     2 | True      |
| 6f2d0dd1-c69d-4522-abfb-e0894c675871 | win-i1-90       |  90000 |   50 |         0 |    16 | True      |
| 743f30ec-a857-4431-8ab6-bf1c32061a29 | s1-4            |   4000 |   20 |         0 |     1 | True      |
| 76768940-3f5e-43d6-9416-6814e05e9e8c | t1-90           |  90000 |  800 |         0 |    18 | True      |
| 788d602a-d3ba-4f50-bad4-19569f20af91 | win-c2-7        |   7000 |   50 |         0 |     2 | True      |
| 7b17f49d-8052-4d9a-8d1b-b8c95a8bc4ad | i1-90           |  90000 |   50 |         0 |    16 | True      |
| 8ab060cc-e259-454b-a4e0-1b81d6f8563e | t1-180          | 180000 |   50 |         0 |    36 | True      |
| 8ce73a56-29dd-46da-b7c5-63aa976bb80d | d2-8            |   8000 |   50 |         0 |     4 | True      |
| 8fbec0a1-03cf-47ec-9c59-0dbaa7d40a99 | c2-120          | 120000 |  400 |         0 |    32 | True      |
| 939c7293-5696-491c-b5b8-eb36ac95582a | r2-15           |  15000 |   50 |         0 |     2 | True      |
| 97d824f9-d8a4-42c4-85b1-275bdd86eafc | r2-60           |  60000 |  100 |         0 |     4 | True      |
| 9aaed1aa-8601-4783-a966-0469bf7f5781 | r2-120-flex     | 120000 |   50 |         0 |     8 | True      |
| 9c58101b-62a4-4205-93d2-f7cddba586d3 | c2-7            |   7000 |   50 |         0 |     2 | True      |
| 9e0428b6-b236-420b-bb8c-d413aaa1b759 | c2-60-flex      |  60000 |   50 |         0 |    16 | True      |
| a467967a-7578-4cdb-97c3-a554a40c3c44 | win-t2-45       |  45000 |  400 |         0 |    14 | True      |
| a9d7f64f-1e57-4d17-9ce3-f73a4c2a9342 | win-t1-90       |  90000 |  800 |         0 |    18 | True      |
| ad323ceb-962d-462e-8e41-251623f37949 | s1-8            |   8000 |   40 |         0 |     2 | True      |
| ae25ae3e-3dcc-473a-91a8-afa5401b17c9 | win-i1-180      | 180000 |   50 |         0 |    32 | True      |
| b4085963-589e-4bf4-9ba7-9170eb8d4b65 | win-c2-7-flex   |   7000 |   50 |         0 |     2 | True      |
| b4e38011-e5e3-40d3-b920-20b3c1b384a4 | b2-15           |  15000 |  100 |         0 |     4 | True      |
| b4e38adb-459f-4f54-b35f-eb0eab88a122 | r2-60-flex      |  60000 |   50 |         0 |     4 | True      |
| b783c2e8-1827-4229-87e6-69a30da939ee | t2-180          | 180000 |   50 |         0 |    60 | True      |
| b8492aff-a3cf-4b4b-9689-be7d4ec435da | r2-30           |  30000 |   50 |         0 |     2 | True      |
| bc7c2c57-4391-4fb6-81c0-2f3df9e33552 | t1-45           |  45000 |  400 |         0 |     8 | True      |
| bd0ea950-a9e0-4016-b9aa-cf017650eaf2 | win-r2-30-flex  |  30000 |   50 |         0 |     2 | True      |
| c2f4abef-1458-4bc8-a4a3-45a142eb0c44 | b2-120          | 120000 |  400 |         0 |    32 | True      |
| c3b3735a-850f-41ba-bd77-e5317d1feb14 | i1-45           |  45000 |   50 |         0 |     8 | True      |
| c57f11cd-f612-4a61-890b-f7ce3f5ec9a2 | win-b2-30       |  30000 |  200 |         0 |     8 | True      |
| c6a31e8b-7ba5-4577-a370-8ec192144660 | win-c2-120-flex | 120000 |   50 |         0 |    32 | True      |
| d03c6295-f876-4701-b6dd-af89fd6f2ce0 | c2-30-flex      |  30000 |   50 |         0 |     8 | True      |
| d65c0411-2cff-41e8-8553-ffc3add96ec9 | r2-30-flex      |  30000 |   50 |         0 |     2 | True      |
| d78db259-423a-4ce8-9892-cb812f725c88 | b2-15-flex      |  15000 |   50 |         0 |     4 | True      |
| d8520532-8114-4870-8cfa-744662d2a59f | win-t2-180      | 180000 |   50 |         0 |    56 | True      |
| dc9d4cdd-bac1-4fbb-9615-5834956ee4e9 | c2-15           |  15000 |  100 |         0 |     4 | True      |
| dcde8fb2-9fcc-4da5-bbb3-5c181e68dfe7 | win-b2-30-flex  |  30000 |   50 |         0 |     8 | True      |
| df39c77e-6503-41da-8781-dc79edcd0138 | win-r2-120-flex | 120000 |   50 |         0 |     8 | True      |
| df647799-904e-4d8e-8575-7d26f13e1af4 | win-b2-120      | 120000 |  400 |         0 |    32 | True      |
| e19ede71-744e-482a-a635-12732c39cab2 | d2-2            |   2000 |   25 |         0 |     1 | True      |
| e5235900-ed7d-4487-a910-21c8b95cad52 | win-c2-15       |  15000 |  100 |         0 |     4 | True      |
| e96620a0-1d3a-48d3-b27d-fa8829560b30 | r2-15-flex      |  15000 |   50 |         0 |     2 | True      |
| e9ecbcf7-70da-4645-83b5-f30a5f203938 | win-t1-45       |  45000 |  400 |         0 |     8 | True      |
| ed94e964-9eb8-41f0-bd7a-6b19038d72c6 | t2-90           |  90000 |  800 |         0 |    30 | True      |
| edcaefe1-ef76-4fbd-be04-18b05997083b | i1-180          | 180000 |   50 |         0 |    32 | True      |
| f63a48cc-5eab-4dc8-9129-15ae808a2bed | c2-30           |  30000 |  200 |         0 |     8 | True      |
| f766d2a1-116c-4238-9d1b-2ba9d82961aa | win-b2-7        |   7000 |   50 |         0 |     2 | True      |
| fa5b8643-999d-4729-98e7-7556c095fd92 | win-b2-15-flex  |  15000 |   50 |         0 |     4 | True      |
| fc4ee7b9-823f-40fe-ace9-9d67edc4bee0 | t2-45           |  45000 |  400 |         0 |    15 | True      |
| ff159611-3233-4c43-b0f1-c47e3d6c0faa | win-i1-45       |  45000 |   50 |         0 |     8 | True      |
+--------------------------------------+-----------------+--------+------+-----------+-------+-----------+
```

</details>

### MySQL database part

This variables are needed by the [Managed MySQL Database with private network Module](../../modules/kubernetes/database/mysql_pvnw).

#### MySQL Engine

```terraform
db_engine = {
  region          = "GRA"
  pv_network_name = "myNetwork"
  subnet_name     = "mySubnet"
  description     = "myMysqlDb"
  engine          = "mysql"
  version         = "8"
  plan            = "business"
  flavor          = "db1-7"
  user_name       = "myuser"
  allowed_ip      = ["192.168.12.0/24"]
}
```

- `region`: The region where this database engine is deployed. Get the region full list on the [capabilities](https://docs.ovh.com/gb/en/publiccloud/databases/mysql/capabilities/) page.

- `pv_network_name`: The private network on which the engine is accessed.

- `subnet_name`: The subnet name where engine nodes are deployed.

- `description`: The name of the database engine.

- `engine`: The engine type. Get the complete list of engines and prices on the [OVHcloud prices page](https://www.ovhcloud.com/en-gb/public-cloud/prices/#databases), in the `Databases` section.

- `version`: The engine version.

- `plan`: The financial plan. Possible values are `essential`, `business` and `enterprise`.

- `flavor`: The flavor type of the nodes. Get the complete list of possible flavors on the [OVHcloud prices page](https://www.ovhcloud.com/en-gb/public-cloud/prices/#7221), in the `Databases`/`MySQL` section.

- `user_name`: The name of the created user on the engine.

- `allowed_ip`: The list of IP ranges (CIDR format).

#### MySQL database

```terraform
db = {
  name = "wordpressDb"
}
```

- `name`: The MySQL database name.

## Deploy

```bash
terraform init
```

<details><summary> 📍 Click to see console output</summary>

```log
$ terraform init
Initializing modules...
- kube in ../../modules/kubernetes/k8s_pvnw
- mysql in ../../modules/database/mysql_pvnw
- network in ../../modules/private_network

Initializing the backend...

Initializing provider plugins...
- Finding ovh/ovh versions matching "~> 0.25.0"...
- Finding hashicorp/helm versions matching ">= 1.0.0"...
- Finding hashicorp/local versions matching "~> 2.2.3"...
- Finding terraform-provider-openstack/openstack versions matching "~> 1.49.0"...
- Installing ovh/ovh v0.25.0...
- Installed ovh/ovh v0.25.0 (signed by a HashiCorp partner, key ID F56D1A6CBDAAADA5)
- Installing hashicorp/helm v2.8.0...
- Installed hashicorp/helm v2.8.0 (signed by HashiCorp)
- Installing hashicorp/local v2.2.3...
- Installed hashicorp/local v2.2.3 (signed by HashiCorp)
- Installing terraform-provider-openstack/openstack v1.49.0...
- Installed terraform-provider-openstack/openstack v1.49.0 (self-signed, key ID 4F80527A391BEFD2)

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

</details>

```bash
terraform plan -var-file=variables.tfvars
```

<details><summary> 📍 Click to see console output</summary>

```log
$ terraform plan -var-file=variables.tfvars
module.network.data.openstack_networking_network_v2.ext_net: Reading...
module.network.data.openstack_networking_network_v2.ext_net: Read complete after 1s [id=xxxxxxxx-a82c-4dc4-a576-xxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # helm_release.wordpress will be created
  + resource "helm_release" "wordpress" {
      + atomic                     = false
      + chart                      = "wordpress"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "wordpress"
      + namespace                  = "default"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://charts.bitnami.com/bitnami"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "15.2.23"
      + wait                       = true
      + wait_for_jobs              = false

      + set {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }
    }

  # local_file.kubeconfig_file will be created
  + resource "local_file" "kubeconfig_file" {
      + content              = (sensitive value)
      + directory_permission = "0777"
      + file_permission      = "0644"
      + filename             = "kubeconfig_file"
      + id                   = (known after apply)
    }

  # module.kube.data.openstack_networking_network_v2.my_private_network will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "openstack_networking_network_v2" "my_private_network" {
      + admin_state_up          = (known after apply)
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + dns_domain              = (known after apply)
      + id                      = (known after apply)
      + name                    = "myNetwork"
      + region                  = "GRA7"
      + shared                  = (known after apply)
      + subnets                 = (known after apply)
    }

  # module.kube.ovh_cloud_project_kube.kube will be created
  + resource "ovh_cloud_project_kube" "kube" {
      + control_plane_is_up_to_date = (known after apply)
      + id                          = (known after apply)
      + is_up_to_date               = (known after apply)
      + kubeconfig                  = (sensitive value)
      + name                        = "mykubernetesCluster"
      + next_upgrade_versions       = (known after apply)
      + nodes_url                   = (known after apply)
      + private_network_id          = (known after apply)
      + region                      = "GRA7"
      + service_name                = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status                      = (known after apply)
      + update_policy               = (known after apply)
      + url                         = (known after apply)
      + version                     = (known after apply)

      + customization {
          + apiserver {
              + admissionplugins {
                  + disabled = (known after apply)
                  + enabled  = (known after apply)
                }
            }
        }

      + private_network_configuration {
          + default_vrack_gateway              = "192.168.29.1"
          + private_network_routing_as_default = true
        }
    }

  # module.kube.ovh_cloud_project_kube_nodepool.my_pool will be created
  + resource "ovh_cloud_project_kube_nodepool" "my_pool" {
      + anti_affinity    = false
      + autoscale        = false
      + available_nodes  = (known after apply)
      + created_at       = (known after apply)
      + current_nodes    = (known after apply)
      + desired_nodes    = 3
      + flavor           = (known after apply)
      + flavor_name      = "b2-7"
      + id               = (known after apply)
      + kube_id          = (known after apply)
      + max_nodes        = 6
      + min_nodes        = 3
      + monthly_billed   = false
      + name             = "mypool"
      + project_id       = (known after apply)
      + service_name     = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + size_status      = (known after apply)
      + status           = (known after apply)
      + up_to_date_nodes = (known after apply)
      + updated_at       = (known after apply)
    }

  # module.mysql.data.openstack_networking_network_v2.my_private_network will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "openstack_networking_network_v2" "my_private_network" {
      + admin_state_up          = (known after apply)
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + dns_domain              = (known after apply)
      + id                      = (known after apply)
      + name                    = "myNetwork"
      + region                  = "GRA7"
      + shared                  = (known after apply)
      + subnets                 = (known after apply)
    }

  # module.mysql.data.openstack_networking_subnet_v2.my_subnet will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "openstack_networking_subnet_v2" "my_subnet" {
      + all_tags          = (known after apply)
      + allocation_pools  = (known after apply)
      + cidr              = (known after apply)
      + description       = (known after apply)
      + dns_nameservers   = (known after apply)
      + enable_dhcp       = (known after apply)
      + gateway_ip        = (known after apply)
      + host_routes       = (known after apply)
      + id                = (known after apply)
      + ip_version        = (known after apply)
      + ipv6_address_mode = (known after apply)
      + ipv6_ra_mode      = (known after apply)
      + name              = "mySubnet"
      + network_id        = (known after apply)
      + region            = "GRA7"
      + service_types     = (known after apply)
      + subnet_id         = (known after apply)
      + subnetpool_id     = (known after apply)
      + tenant_id         = (known after apply)
    }

  # module.mysql.ovh_cloud_project_database.mysql_engine will be created
  + resource "ovh_cloud_project_database" "mysql_engine" {
      + backup_time      = (known after apply)
      + created_at       = (known after apply)
      + description      = "myMysqlDb"
      + disk_size        = (known after apply)
      + disk_type        = (known after apply)
      + endpoints        = (known after apply)
      + engine           = "mysql"
      + flavor           = "db1-7"
      + id               = (known after apply)
      + maintenance_time = (known after apply)
      + network_type     = (known after apply)
      + plan             = "business"
      + service_name     = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status           = (known after apply)
      + version          = "8"

      + nodes {
          + network_id = (known after apply)
          + region     = "GRA"
          + subnet_id  = (known after apply)
        }
      + nodes {
          + network_id = (known after apply)
          + region     = "GRA"
          + subnet_id  = (known after apply)
        }
    }

  # module.mysql.ovh_cloud_project_database_database.database will be created
  + resource "ovh_cloud_project_database_database" "database" {
      + cluster_id   = (known after apply)
      + default      = (known after apply)
      + engine       = "mysql"
      + id           = (known after apply)
      + name         = "wordpressDb"
      + service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
    }

  # module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"] will be created
  + resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      + cluster_id   = (known after apply)
      + engine       = "mysql"
      + id           = (known after apply)
      + ip           = "192.168.29.0/24"
      + service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status       = (known after apply)
    }

  # module.mysql.ovh_cloud_project_database_user.mysqluser will be created
  + resource "ovh_cloud_project_database_user" "mysqluser" {
      + cluster_id     = (known after apply)
      + created_at     = (known after apply)
      + engine         = "mysql"
      + id             = (known after apply)
      + name           = "myuser"
      + password       = (sensitive value)
      + password_reset = "changeMeToResetPassword"
      + service_name   = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status         = (known after apply)
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
      + external_network_id     = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxx"
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
      + cidr              = "192.168.29.0/24"
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
          + end   = "192.168.29.254"
          + start = "192.168.29.100"
        }

      + allocation_pools {
          + end   = (known after apply)
          + start = (known after apply)
        }
    }

Plan: 12 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

</details>

```bash
terraform apply -var-file=variables.tfvars
```

<details><summary> 📍 Click to see console output</summary>

```log
$ terraform apply -var-file=variables.tfvars
module.network.data.openstack_networking_network_v2.ext_net: Reading...
module.network.data.openstack_networking_network_v2.ext_net: Read complete after 1s [id=xxxxxxxx-a82c-4dc4-a576-xxxxxxxx]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # helm_release.wordpress will be created
  + resource "helm_release" "wordpress" {
      + atomic                     = false
      + chart                      = "wordpress"
      + cleanup_on_fail            = false
      + create_namespace           = false
      + dependency_update          = false
      + disable_crd_hooks          = false
      + disable_openapi_validation = false
      + disable_webhooks           = false
      + force_update               = false
      + id                         = (known after apply)
      + lint                       = false
      + manifest                   = (known after apply)
      + max_history                = 0
      + metadata                   = (known after apply)
      + name                       = "wordpress"
      + namespace                  = "default"
      + pass_credentials           = false
      + recreate_pods              = false
      + render_subchart_notes      = true
      + replace                    = false
      + repository                 = "https://charts.bitnami.com/bitnami"
      + reset_values               = false
      + reuse_values               = false
      + skip_crds                  = false
      + status                     = "deployed"
      + timeout                    = 300
      + verify                     = false
      + version                    = "15.2.23"
      + wait                       = true
      + wait_for_jobs              = false

      + set {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }
    }

  # local_file.kubeconfig_file will be created
  + resource "local_file" "kubeconfig_file" {
      + content              = (sensitive value)
      + directory_permission = "0777"
      + file_permission      = "0644"
      + filename             = "kubeconfig_file"
      + id                   = (known after apply)
    }

  # module.kube.data.openstack_networking_network_v2.my_private_network will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "openstack_networking_network_v2" "my_private_network" {
      + admin_state_up          = (known after apply)
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + dns_domain              = (known after apply)
      + id                      = (known after apply)
      + name                    = "myNetwork"
      + region                  = "GRA7"
      + shared                  = (known after apply)
      + subnets                 = (known after apply)
    }

  # module.kube.ovh_cloud_project_kube.kube will be created
  + resource "ovh_cloud_project_kube" "kube" {
      + control_plane_is_up_to_date = (known after apply)
      + id                          = (known after apply)
      + is_up_to_date               = (known after apply)
      + kubeconfig                  = (sensitive value)
      + name                        = "mykubernetesCluster"
      + next_upgrade_versions       = (known after apply)
      + nodes_url                   = (known after apply)
      + private_network_id          = (known after apply)
      + region                      = "GRA7"
      + service_name                = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status                      = (known after apply)
      + update_policy               = (known after apply)
      + url                         = (known after apply)
      + version                     = (known after apply)

      + customization {
          + apiserver {
              + admissionplugins {
                  + disabled = (known after apply)
                  + enabled  = (known after apply)
                }
            }
        }

      + private_network_configuration {
          + default_vrack_gateway              = "192.168.29.1"
          + private_network_routing_as_default = true
        }
    }

  # module.kube.ovh_cloud_project_kube_nodepool.my_pool will be created
  + resource "ovh_cloud_project_kube_nodepool" "my_pool" {
      + anti_affinity    = false
      + autoscale        = false
      + available_nodes  = (known after apply)
      + created_at       = (known after apply)
      + current_nodes    = (known after apply)
      + desired_nodes    = 3
      + flavor           = (known after apply)
      + flavor_name      = "b2-7"
      + id               = (known after apply)
      + kube_id          = (known after apply)
      + max_nodes        = 6
      + min_nodes        = 3
      + monthly_billed   = false
      + name             = "mypool"
      + project_id       = (known after apply)
      + service_name     = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + size_status      = (known after apply)
      + status           = (known after apply)
      + up_to_date_nodes = (known after apply)
      + updated_at       = (known after apply)
    }

  # module.mysql.data.openstack_networking_network_v2.my_private_network will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "openstack_networking_network_v2" "my_private_network" {
      + admin_state_up          = (known after apply)
      + all_tags                = (known after apply)
      + availability_zone_hints = (known after apply)
      + dns_domain              = (known after apply)
      + id                      = (known after apply)
      + name                    = "myNetwork"
      + region                  = "GRA7"
      + shared                  = (known after apply)
      + subnets                 = (known after apply)
    }

  # module.mysql.data.openstack_networking_subnet_v2.my_subnet will be read during apply
  # (depends on a resource or a module with changes pending)
 <= data "openstack_networking_subnet_v2" "my_subnet" {
      + all_tags          = (known after apply)
      + allocation_pools  = (known after apply)
      + cidr              = (known after apply)
      + description       = (known after apply)
      + dns_nameservers   = (known after apply)
      + enable_dhcp       = (known after apply)
      + gateway_ip        = (known after apply)
      + host_routes       = (known after apply)
      + id                = (known after apply)
      + ip_version        = (known after apply)
      + ipv6_address_mode = (known after apply)
      + ipv6_ra_mode      = (known after apply)
      + name              = "mySubnet"
      + network_id        = (known after apply)
      + region            = "GRA7"
      + service_types     = (known after apply)
      + subnet_id         = (known after apply)
      + subnetpool_id     = (known after apply)
      + tenant_id         = (known after apply)
    }

  # module.mysql.ovh_cloud_project_database.mysql_engine will be created
  + resource "ovh_cloud_project_database" "mysql_engine" {
      + backup_time      = (known after apply)
      + created_at       = (known after apply)
      + description      = "myMysqlDb"
      + disk_size        = (known after apply)
      + disk_type        = (known after apply)
      + endpoints        = (known after apply)
      + engine           = "mysql"
      + flavor           = "db1-7"
      + id               = (known after apply)
      + maintenance_time = (known after apply)
      + network_type     = (known after apply)
      + plan             = "business"
      + service_name     = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status           = (known after apply)
      + version          = "8"

      + nodes {
          + network_id = (known after apply)
          + region     = "GRA"
          + subnet_id  = (known after apply)
        }
      + nodes {
          + network_id = (known after apply)
          + region     = "GRA"
          + subnet_id  = (known after apply)
        }
    }

  # module.mysql.ovh_cloud_project_database_database.database will be created
  + resource "ovh_cloud_project_database_database" "database" {
      + cluster_id   = (known after apply)
      + default      = (known after apply)
      + engine       = "mysql"
      + id           = (known after apply)
      + name         = "wordpressDb"
      + service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
    }

  # module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"] will be created
  + resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      + cluster_id   = (known after apply)
      + engine       = "mysql"
      + id           = (known after apply)
      + ip           = "192.168.29.0/24"
      + service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status       = (known after apply)
    }

  # module.mysql.ovh_cloud_project_database_user.mysqluser will be created
  + resource "ovh_cloud_project_database_user" "mysqluser" {
      + cluster_id     = (known after apply)
      + created_at     = (known after apply)
      + engine         = "mysql"
      + id             = (known after apply)
      + name           = "myuser"
      + password       = (sensitive value)
      + password_reset = "changeMeToResetPassword"
      + service_name   = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx"
      + status         = (known after apply)
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
      + external_network_id     = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxx"
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
      + cidr              = "192.168.29.0/24"
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
          + end   = "192.168.29.254"
          + start = "192.168.29.100"
        }

      + allocation_pools {
          + end   = (known after apply)
          + start = (known after apply)
        }
    }

Plan: 12 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

```

</details>

## Usage and test

### Get necessary informations

The deployed wordpress can be accessed by its **Load-Balancer Service public IP**. To get the address, use the `kubectl` cli.

First, configure your kubectl environment to use the generated `kubeconfig_file`:

```bash
export KUBECONFIG="$(pwd)/kubeconfig_file"
```

Then, request the wordpress service IP:

```bash
kubectl get svc wordpress
```

You should have a result like:

```console
NAME        TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)                      AGE
wordpress   LoadBalancer   10.x.xxx.xxx   135.xxx.xx.xxx   80:31746/TCP,443:30304/TCP   3h2m
```

Copy the IP address under **EXTERNAL-IP** and paste it inside a web browser, you should get the welcome page like this:

![Wordpress Welcome Page](./img/ex03_01.png)

## Destroy

To destroy and remove everything, use the terraform destroy command:

```bash
terraform destroy -var-file=variables.tfvars
```

<details><summary> 📍 Click to see console output</summary>

```log
$ terraform destroy -var-file=variables.tfvars
module.network.data.openstack_networking_network_v2.ext_net: Reading...
module.network.openstack_networking_network_v2.my_private_network: Refreshing state... [id=xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx]
module.network.openstack_networking_subnet_v2.my_subnet: Refreshing state... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx]
module.network.data.openstack_networking_network_v2.ext_net: Read complete after 2s [id=xxxxxxxx-a82c-4dc4-a576-xxxxxxxx]
module.network.openstack_networking_router_v2.my_router: Refreshing state... [id=xxxxxxxx-7c47-49ab-bbbc-xxxxxxxx]
module.network.openstack_networking_router_interface_v2.my_router_interface: Refreshing state... [id=xxxxxxxx-5a26-4878-b67e-xxxxxxxx]
module.mysql.data.openstack_networking_network_v2.my_private_network: Reading...
module.mysql.data.openstack_networking_subnet_v2.my_subnet: Reading...
module.kube.data.openstack_networking_network_v2.my_private_network: Reading...
module.mysql.data.openstack_networking_subnet_v2.my_subnet: Read complete after 0s [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx]
module.mysql.data.openstack_networking_network_v2.my_private_network: Read complete after 1s [id=xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx]
module.kube.data.openstack_networking_network_v2.my_private_network: Read complete after 1s [id=xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx]
module.mysql.ovh_cloud_project_database.mysql_engine: Refreshing state... [id=xxxxxxxx-9c10-4666-a68a-xxxxxxxx]
module.kube.ovh_cloud_project_kube.kube: Refreshing state... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Refreshing state... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx]
local_file.kubeconfig_file: Refreshing state... [id=xxxxxxxxe528194a8d9bc02be3e2b193xxxxxxxx]
module.mysql.ovh_cloud_project_database_user.mysqluser: Refreshing state... [id=xxxxxxxx-b9d3-4561-993e-xxxxxxxx]
module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"]: Refreshing state... [id=866502489]
module.mysql.ovh_cloud_project_database_database.database: Refreshing state... [id=xxxxxxxx-8ac2-4c51-9242-xxxxxxxx]
helm_release.wordpress: Refreshing state... [id=wordpress]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # helm_release.wordpress will be destroyed
  - resource "helm_release" "wordpress" {
      - atomic                     = false -> null
      - chart                      = "wordpress" -> null
      - cleanup_on_fail            = false -> null
      - create_namespace           = false -> null
      - dependency_update          = false -> null
      - disable_crd_hooks          = false -> null
      - disable_openapi_validation = false -> null
      - disable_webhooks           = false -> null
      - force_update               = false -> null
      - id                         = "wordpress" -> null
      - lint                       = false -> null
      - max_history                = 0 -> null
      - metadata                   = [
          - {
              - app_version = "6.1.1"
              - chart       = "wordpress"
              - name        = "wordpress"
              - namespace   = "default"
              - revision    = 1
              - values      = jsonencode(
                    {
                      - externalDatabase = {
                          - database = "wordpressDb"
                          - host     = "mysql-xxxxxxxx-xxxxxxxxx.database.cloud.ovh.net"
                          - password = "AVNS_y5ebL2uPnJMXZNctxyp"
                          - port     = 20184
                          - user     = "myuser"
                        }
                      - mariadb          = {
                          - enabled = false
                        }
                    }
                )
              - version     = "15.2.23"
            },
        ] -> null
      - name                       = "wordpress" -> null
      - namespace                  = "default" -> null
      - pass_credentials           = false -> null
      - recreate_pods              = false -> null
      - render_subchart_notes      = true -> null
      - replace                    = false -> null
      - repository                 = "https://charts.bitnami.com/bitnami" -> null
      - reset_values               = false -> null
      - reuse_values               = false -> null
      - skip_crds                  = false -> null
      - status                     = "deployed" -> null
      - timeout                    = 300 -> null
      - verify                     = false -> null
      - version                    = "15.2.23" -> null
      - wait                       = true -> null
      - wait_for_jobs              = false -> null

      - set {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }
    }

  # local_file.kubeconfig_file will be destroyed
  - resource "local_file" "kubeconfig_file" {
      - content              = (sensitive value) -> null
      - directory_permission = "0777" -> null
      - file_permission      = "0644" -> null
      - filename             = "kubeconfig_file" -> null
      - id                   = "xxxxxxxxe528194a8d9bc02be3e2b193xxxxxxxx" -> null
    }

  # module.kube.ovh_cloud_project_kube.kube will be destroyed
  - resource "ovh_cloud_project_kube" "kube" {
      - control_plane_is_up_to_date = true -> null
      - id                          = "xxxxxxxx-0113-4f63-bbf8-xxxxxxxx" -> null
      - is_up_to_date               = true -> null
      - kubeconfig                  = (sensitive value)
      - name                        = "mykubernetesCluster" -> null
      - next_upgrade_versions       = [] -> null
      - nodes_url                   = "98fq0k.nodes.c1.gra7.k8s.ovh.net" -> null
      - private_network_id          = "xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx" -> null
      - region                      = "GRA7" -> null
      - service_name                = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status                      = "READY" -> null
      - update_policy               = "ALWAYS_UPDATE" -> null
      - url                         = "98fq0k.c1.gra7.k8s.ovh.net" -> null
      - version                     = "1.25" -> null

      - customization {
          - apiserver {
              - admissionplugins {
                  - disabled = [] -> null
                  - enabled  = [
                      - "AlwaysPullImages",
                      - "NodeRestriction",
                    ] -> null
                }
            }
        }

      - private_network_configuration {
          - default_vrack_gateway              = "192.168.29.1" -> null
          - private_network_routing_as_default = true -> null
        }
    }

  # module.kube.ovh_cloud_project_kube_nodepool.my_pool will be destroyed
  - resource "ovh_cloud_project_kube_nodepool" "my_pool" {
      - anti_affinity    = false -> null
      - autoscale        = false -> null
      - available_nodes  = 3 -> null
      - created_at       = "2023-01-11T09:01:16Z" -> null
      - current_nodes    = 3 -> null
      - desired_nodes    = 3 -> null
      - flavor           = "b2-7" -> null
      - flavor_name      = "b2-7" -> null
      - id               = "xxxxxxxx-5966-49bc-9813-xxxxxxxx" -> null
      - kube_id          = "xxxxxxxx-0113-4f63-bbf8-xxxxxxxx" -> null
      - max_nodes        = 6 -> null
      - min_nodes        = 3 -> null
      - monthly_billed   = false -> null
      - name             = "mypool" -> null
      - project_id       = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - service_name     = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - size_status      = "CAPACITY_OK" -> null
      - status           = "READY" -> null
      - up_to_date_nodes = 3 -> null
      - updated_at       = "2023-01-11T09:08:14Z" -> null
    }

  # module.mysql.ovh_cloud_project_database.mysql_engine will be destroyed
  - resource "ovh_cloud_project_database" "mysql_engine" {
      - backup_time             = "17:03:00" -> null
      - created_at              = "2023-01-11T10:57:15.355837+01:00" -> null
      - description             = "myMysqlDb" -> null
      - disk_size               = 160 -> null
      - disk_type               = "high-speed" -> null
      - endpoints               = [
          - {
              - component = "mysql"
              - domain    = "mysql-xxxxxxxx-xxxxxxxxx.database.cloud.ovh.net"
              - path      = ""
              - port      = 20184
              - scheme    = "mysql"
              - ssl       = true
              - ssl_mode  = "REQUIRED"
              - uri       = "mysql://<username>:<password>@mysql-xxxxxxxx-xxxxxxxxx.database.cloud.ovh.net:20184/defaultdb?ssl-mode=REQUIRED"
            },
          - {
              - component = "mysqlRead"
              - domain    = "replica-mysql-xxxxxxxx-xxxxxxxxx.database.cloud.ovh.net"
              - path      = ""
              - port      = 20184
              - scheme    = "mysql"
              - ssl       = true
              - ssl_mode  = "require"
              - uri       = "mysql://<username>:<password>@replica-mysql-xxxxxxxx-xxxxxxxxx.database.cloud.ovh.net:20184/defaultdb?ssl-mode=REQUIRED"
            },
        ] -> null
      - engine                  = "mysql" -> null
      - flavor                  = "db1-7" -> null
      - id                      = "xxxxxxxx-9c10-4666-a68a-xxxxxxxx" -> null
      - kafka_rest_api          = false -> null
      - maintenance_time        = "09:38:23" -> null
      - network_type            = "private" -> null
      - opensearch_acls_enabled = false -> null
      - plan                    = "business" -> null
      - service_name            = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status                  = "READY" -> null
      - version                 = "8" -> null

      - nodes {
          - network_id = "xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx" -> null
          - region     = "GRA" -> null
          - subnet_id  = "xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx" -> null
        }
      - nodes {
          - network_id = "xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx" -> null
          - region     = "GRA" -> null
          - subnet_id  = "xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx" -> null
        }
    }

  # module.mysql.ovh_cloud_project_database_database.database will be destroyed
  - resource "ovh_cloud_project_database_database" "database" {
      - cluster_id   = "xxxxxxxx-9c10-4666-a68a-xxxxxxxx" -> null
      - default      = false -> null
      - engine       = "mysql" -> null
      - id           = "xxxxxxxx-8ac2-4c51-9242-xxxxxxxx" -> null
      - name         = "wordpressDb" -> null
      - service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
    }

  # module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"] will be destroyed
  - resource "ovh_cloud_project_database_ip_restriction" "iprestriction" {
      - cluster_id   = "xxxxxxxx-9c10-4666-a68a-xxxxxxxx" -> null
      - engine       = "mysql" -> null
      - id           = "866502489" -> null
      - ip           = "192.168.29.0/24" -> null
      - service_name = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status       = "READY" -> null
    }

  # module.mysql.ovh_cloud_project_database_user.mysqluser will be destroyed
  - resource "ovh_cloud_project_database_user" "mysqluser" {
      - cluster_id     = "xxxxxxxx-9c10-4666-a68a-xxxxxxxx" -> null
      - created_at     = "2023-01-11T11:02:14.024332+01:00" -> null
      - engine         = "mysql" -> null
      - id             = "xxxxxxxx-b9d3-4561-993e-xxxxxxxx" -> null
      - name           = "myuser" -> null
      - password       = (sensitive value)
      - password_reset = "changeMeToResetPassword" -> null
      - service_name   = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null
      - status         = "READY" -> null
    }

  # module.network.openstack_networking_network_v2.my_private_network will be destroyed
  - resource "openstack_networking_network_v2" "my_private_network" {
      - admin_state_up          = true -> null
      - all_tags                = [] -> null
      - availability_zone_hints = [] -> null
      - external                = false -> null
      - id                      = "xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx" -> null
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
      - id        = "xxxxxxxx-5a26-4878-b67e-xxxxxxxx" -> null
      - port_id   = "xxxxxxxx-5a26-4878-b67e-xxxxxxxx" -> null
      - region    = "GRA7" -> null
      - router_id = "xxxxxxxx-7c47-49ab-bbbc-xxxxxxxx" -> null
      - subnet_id = "xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx" -> null
    }

  # module.network.openstack_networking_router_v2.my_router will be destroyed
  - resource "openstack_networking_router_v2" "my_router" {
      - admin_state_up          = true -> null
      - all_tags                = [] -> null
      - availability_zone_hints = [] -> null
      - distributed             = false -> null
      - enable_snat             = true -> null
      - external_gateway        = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxx" -> null
      - external_network_id     = "xxxxxxxx-a82c-4dc4-a576-xxxxxxxx" -> null
      - id                      = "xxxxxxxx-7c47-49ab-bbbc-xxxxxxxx" -> null
      - name                    = "myRouter" -> null
      - region                  = "GRA7" -> null
      - tags                    = [] -> null
      - tenant_id               = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null

      - external_fixed_ip {
          - ip_address = "51.178.58.67" -> null
          - subnet_id  = "6559fcab-dc60-4528-a16a-ea7ac64933a7" -> null
        }
    }

  # module.network.openstack_networking_subnet_v2.my_subnet will be destroyed
  - resource "openstack_networking_subnet_v2" "my_subnet" {
      - all_tags        = [] -> null
      - cidr            = "192.168.29.0/24" -> null
      - dns_nameservers = [
          - "1.1.1.1",
          - "1.0.0.1",
        ] -> null
      - enable_dhcp     = true -> null
      - gateway_ip      = "192.168.29.1" -> null
      - id              = "xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx" -> null
      - ip_version      = 4 -> null
      - name            = "mySubnet" -> null
      - network_id      = "xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx" -> null
      - no_gateway      = false -> null
      - region          = "GRA7" -> null
      - service_types   = [] -> null
      - tags            = [] -> null
      - tenant_id       = "xxxxxxxx1da24017a6a6f6b6xxxxxxxx" -> null

      - allocation_pool {
          - end   = "192.168.29.254" -> null
          - start = "192.168.29.100" -> null
        }

      - allocation_pools {
          - end   = "192.168.29.254" -> null
          - start = "192.168.29.100" -> null
        }
    }

Plan: 0 to add, 0 to change, 12 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

helm_release.wordpress: Destroying... [id=wordpress]
helm_release.wordpress: Destruction complete after 4s
module.mysql.ovh_cloud_project_database_database.database: Destroying... [id=xxxxxxxx-8ac2-4c51-9242-xxxxxxxx]
module.mysql.ovh_cloud_project_database_user.mysqluser: Destroying... [id=xxxxxxxx-b9d3-4561-993e-xxxxxxxx]
module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"]: Destroying... [id=866502489]
local_file.kubeconfig_file: Destroying... [id=xxxxxxxxe528194a8d9bc02be3e2b193xxxxxxxx]
local_file.kubeconfig_file: Destruction complete after 0s
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx]
module.mysql.ovh_cloud_project_database_database.database: Still destroying... [id=xxxxxxxx-8ac2-4c51-9242-xxxxxxxx, 10s elapsed]
module.mysql.ovh_cloud_project_database_user.mysqluser: Still destroying... [id=xxxxxxxx-b9d3-4561-993e-xxxxxxxx, 10s elapsed]
module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"]: Still destroying... [id=866502489, 10s elapsed]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 10s elapsed]
module.mysql.ovh_cloud_project_database_user.mysqluser: Destruction complete after 11s
module.mysql.ovh_cloud_project_database_database.database: Destruction complete after 11s
module.mysql.ovh_cloud_project_database_ip_restriction.iprestriction["192.168.29.0/24"]: Destruction complete after 11s
module.mysql.ovh_cloud_project_database.mysql_engine: Destroying... [id=xxxxxxxx-9c10-4666-a68a-xxxxxxxx]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 20s elapsed]
module.mysql.ovh_cloud_project_database.mysql_engine: Still destroying... [id=xxxxxxxx-9c10-4666-a68a-xxxxxxxx, 10s elapsed]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 30s elapsed]
module.mysql.ovh_cloud_project_database.mysql_engine: Still destroying... [id=xxxxxxxx-9c10-4666-a68a-xxxxxxxx, 20s elapsed]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 40s elapsed]
module.mysql.ovh_cloud_project_database.mysql_engine: Still destroying... [id=xxxxxxxx-9c10-4666-a68a-xxxxxxxx, 30s elapsed]
module.mysql.ovh_cloud_project_database.mysql_engine: Destruction complete after 33s
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 50s elapsed]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 1m0s elapsed]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Still destroying... [id=xxxxxxxx-5966-49bc-9813-xxxxxxxx, 1m10s elapsed]
module.kube.ovh_cloud_project_kube_nodepool.my_pool: Destruction complete after 1m17s
module.kube.ovh_cloud_project_kube.kube: Destroying... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx]
module.kube.ovh_cloud_project_kube.kube: Still destroying... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx, 10s elapsed]
module.kube.ovh_cloud_project_kube.kube: Still destroying... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx, 20s elapsed]
module.kube.ovh_cloud_project_kube.kube: Still destroying... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx, 30s elapsed]
module.kube.ovh_cloud_project_kube.kube: Still destroying... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx, 40s elapsed]
module.kube.ovh_cloud_project_kube.kube: Still destroying... [id=xxxxxxxx-0113-4f63-bbf8-xxxxxxxx, 50s elapsed]
module.kube.ovh_cloud_project_kube.kube: Destruction complete after 56s
module.network.openstack_networking_router_interface_v2.my_router_interface: Destroying... [id=xxxxxxxx-5a26-4878-b67e-xxxxxxxx]
module.network.openstack_networking_router_interface_v2.my_router_interface: Still destroying... [id=xxxxxxxx-5a26-4878-b67e-xxxxxxxx, 10s elapsed]
module.network.openstack_networking_router_interface_v2.my_router_interface: Destruction complete after 15s
module.network.openstack_networking_router_v2.my_router: Destroying... [id=xxxxxxxx-7c47-49ab-bbbc-xxxxxxxx]
module.network.openstack_networking_subnet_v2.my_subnet: Destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx]
module.network.openstack_networking_router_v2.my_router: Still destroying... [id=xxxxxxxx-7c47-49ab-bbbc-xxxxxxxx, 10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 10s elapsed]
module.network.openstack_networking_router_v2.my_router: Destruction complete after 11s
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 1m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 1m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 1m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 1m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 1m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 1m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 2m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 2m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 2m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 2m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 2m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 2m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 3m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 3m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 3m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 3m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 3m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 3m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 4m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 4m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 4m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 4m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 4m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 4m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 5m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 5m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 5m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 5m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 5m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 5m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 6m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 6m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 6m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 6m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 6m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 6m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 7m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 7m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 7m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 7m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 7m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 7m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 8m0s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 8m10s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 8m20s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 8m30s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 8m40s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Still destroying... [id=xxxxxxxx-9cef-42fe-aaa2-xxxxxxxx, 8m50s elapsed]
module.network.openstack_networking_subnet_v2.my_subnet: Destruction complete after 8m59s
module.network.openstack_networking_network_v2.my_private_network: Destroying... [id=xxxxxxxx-82f0-4aa8-a0eb-xxxxxxxx]
module.network.openstack_networking_network_v2.my_private_network: Destruction complete after 6s

Destroy complete! Resources: 12 destroyed.
```

</details>


