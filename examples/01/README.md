# A virtual machine connected to a private network

## Description

This example shows you how to create and access to a virtual machine that is connected to a private network, with [Terraform](https://www.terraform.io).

This server, called `bastion`, will be accessed with SSH protocol, and served by an openstack floating IP.

This example handle following resources: 

- Private network

- Subnet with DHCP range

- Virtual Router

- Floating IP

- SSH Keypair

- Vitual Machine (VM) Instance

![Example 01 schema](./img/01.png)

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

### SSH keypair part

```terraform
keypair = {
  name                 = "myMainKeypair"
  main_region          = "GRA7"
  to_reproduce_regions = []
  keys_path            = "."
}
```

This variables are needed by the [SSH keypair module](../../modules/ssh_keypair)

- `name`: The keypair name.

- `main_region`: The region where the SSH keypair is deployed.

- `to_reproduce_regions`: (Not applicable in this example, let the `[]` value) Add another regions if you want to deploy the created SSH public key inside.

- `keys_path`: The path where the SSH private and public keys files will be created.

### Virtual Machine part

This variables are needed by the [Simple instance module](../../modules/instance_simple)

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

- `region`: The region where this instance is deployed, must be the same value as the network and SSH keypair modules.

- `network_name`: The name of the private network, as previously defined.

- `keypair_name`: The name of the SSH keypair, as previously defined.

- `flavor`: The flavor type of the instance.

- `image`: The OS image of the instance.

- `user`: The linux user created on the instance. The SSH public key will be deployed.

Note: If you have followed the [Starting Pack to manage your OVHcloud Services from shell](../../basics/README.md) tutorial, and have an openstack cli well configured, you can get the image and flavor list with this commands:

```bash
openstack --os-region-name=XXX flavor list
openstack --os-region-name=XXX image list
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
$ openstack --os-region-name=GRA7 image list
+--------------------------------------+-----------------------------------------------+--------+
| ID                                   | Name                                          | Status |
+--------------------------------------+-----------------------------------------------+--------+
| b1a33c89-478c-402c-8f4b-94b62c8fb310 | AlmaLinux 8                                   | active |
| 28b71e95-e2d2-4c09-b830-9c32916b2766 | AlmaLinux 8 - UEFI                            | active |
| 6233e96a-3a95-4ab3-a78b-90c5163923a5 | AlmaLinux 8 - cPanel                          | active |
| c029df6d-ce06-49f6-a834-38211e08f467 | AlmaLinux 9                                   | active |
| aa74789b-f153-40a9-8a55-09a9fc6fc98d | AlmaLinux 9 - UEFI                            | active |
| ded9ccd7-6f24-4e5e-be63-d5e8747b0d9e | Centos 7                                      | active |
| 941869ff-b0a9-459c-b771-f5874a98b635 | Centos 7 - Analytics - Ambari pre-warmed      | active |
| 02d0c8ab-5dfb-44a0-8a28-31fcec6f258d | Centos 7 - Analytics - Base image             | active |
| c8c9f5c8-37fe-4577-a039-e1c2e5c0029c | Centos 7 - Analytics - Guacamole              | active |
| c9e5f425-b1c0-4767-b5dc-fc0a5c7a35b4 | Centos 7 - Analytics - Kerberos               | active |
| 6234f7b2-8f3a-4361-8b8b-57510e45cbb8 | Centos 7 - Analytics - MySql                  | active |
| f022a433-44ad-4055-94a7-20cbd4c47d41 | Centos 7 - UEFI                               | active |
| 49ae8123-ec46-4b97-83d7-13b930fe2c61 | Centos 7 - cPanel                             | active |
| d1c0859e-fd15-4f28-9c0b-7bfa877ee4cb | CloudLinux 8                                  | active |
| 7ab4bc8c-fc0d-40b9-8047-9d5f7cfc246b | Community - Analytics - Spark service         | active |
| a908b15f-2702-4c30-83d0-5140abfde677 | Debian 10                                     | active |
| 0faff8ef-38a3-4fb3-b506-3b1a949e1abf | Debian 10 - Docker                            | active |
| 2cc539f0-8ba5-4cb1-ae2a-bbb517b2e05a | Debian 10 - IaaS hardened                     | active |
| 7c6d92ed-97e1-4496-818a-c1c8a8367774 | Debian 10 - Plesk                             | active |
| 0b74822e-925c-4e98-975c-9e331dd2e6f6 | Debian 11                                     | active |
| 6f4ea1d8-f602-4704-a47d-f813a5676833 | Debian 11 - UEFI                              | active |
| be898ecb-ef01-4faf-b51b-853d04345f49 | Debian 9                                      | active |
| e2b2e2fb-ab9a-4cf2-a50d-a8d4f9368868 | Debian 9 - DataScience                        | active |
| 13d51ff9-3461-4a8f-a453-ab0a73a9364f | Debian 9 - Dataiku DSS 5.1.3                  | active |
| 50431c19-989a-46a5-9d6e-2d62b6933d26 | Debian 9 - IaaS hardened                      | active |
| 2977f552-9f82-4fcf-858b-c32787445657 | Debian 9 - Minikube                           | active |
| 82d66026-6491-495f-8e47-d845c3b6d9fe | Fedora 34                                     | active |
| fb82e4dc-ee14-4140-9a3d-b7c4682410f2 | Fedora 35                                     | active |
| e783cf64-1cd1-4f89-a60d-a5a19d92e4f6 | Fedora 35 - UEFI                              | active |
| 2e45e135-cfb6-4df9-ac09-3a1a1902fed1 | Fedora 36                                     | active |
| 010f967d-ee11-4255-9e50-eed69ed5b2b0 | Fedora 36 - UEFI                              | active |
| fdfaedde-5fcd-4f85-abf8-430d23b9e2b0 | NVIDIA GPU Cloud (NGC)                        | active |
| 79bbff18-d5db-4c37-91f0-2a70ebb17b39 | Rocky Linux 8                                 | active |
| 8659433f-ffa7-49ca-acee-509e2a8ab589 | Rocky Linux 9                                 | active |
| c3f455a6-e450-4637-91bd-0f9d4af5cb03 | Ubuntu 18.04                                  | active |
| a74be1dd-35f4-4a65-b9bc-55ebc1bf10e2 | Ubuntu 18.04 - UEFI                           | active |
| ff40b983-fb54-40f7-8289-fe522ebdffb7 | Ubuntu 20.04                                  | active |
| a2724de5-da0f-4176-b2a3-3f1186e5ff31 | Ubuntu 20.04 - UEFI                           | active |
| 8e90c938-9f4e-46af-b3ab-4ce6bde4c18b | Ubuntu 21.04                                  | active |
| 158eeead-5f82-4c51-9959-7de9cd9eab7c | Ubuntu 21.10                                  | active |
| a3052eb9-2a00-45f9-bdaa-75a536620a1f | Ubuntu 21.10 - UEFI                           | active |
| 8406c957-c25c-42c6-b1e5-88cba36c66d6 | Ubuntu 22.04                                  | active |
| 6231db12-10d7-488c-9a7b-2bd6733107a6 | Ubuntu 22.04 - UEFI                           | active |
| cef4f924-b6dc-4fb8-a522-5f05c22f137f | Ubuntu 22.10                                  | active |
| 884f06f6-16c3-433a-b9e6-e58392bfec3f | Ubuntu 22.10 - UEFI                           | active |
| fb69a301-b990-440f-811b-ba877703c675 | Windows Server 2012 R2 Standard - UEFI        | active |
| 963b6fae-40e4-4788-ae90-b71d1bf40cf5 | Windows Server 2016 Standard (Desktop)        | active |
| 4d04e2cc-a9fd-46ba-9dca-bdcf96a16793 | Windows Server 2016 Standard (Desktop) - UEFI | active |
| 702660cf-2bdc-4a96-b4d9-a32aff405681 | Windows Server 2019 Standard (Desktop)        | active |
| 54b5dc86-c1a3-4bff-a19a-46be32fc6816 | Windows Server 2019 Standard (Desktop) - UEFI | active |
| 8b4d4743-509a-4102-99ff-48dddaca05a7 | Windows Server 2022 Standard (Desktop)        | active |
| 981b00d5-e457-49e6-ac41-3a7febaf6e2a | Windows Server 2022 Standard (Desktop) - UEFI | active |
| 5d35921c-5438-4566-86af-d77855b274ad | Windows-Server-2012-r2                        | active |
| dbc3cafd-dc92-4de2-bb99-6a8edfe6698a | rescue-ovh                                    | active |
+--------------------------------------+-----------------------------------------------+--------+
```

</details>

## Deploy

```bash
terraform init
```

<details><summary> 📍 Click to see console output</summary>

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

</details>

```bash
terraform plan -var-file=variables.tfvars
```

<details><summary> 📍 Click to see console output</summary>

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

<details><summary> 📍 Click to see console output</summary>

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

- `bastion_floating_ip`: The public IP address to access the bastion instance.

- `bastion_private_ip`: The private IP address of the bastion instance.

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

<details><summary> 📍 Click to see console output</summary>

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
