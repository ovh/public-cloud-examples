# Create instances with K3s installed on OVHcloud Public Cloud

This is how to create many instances with [K3s](https://k3s.io/), a lightweight Kubernetes, installed on.

Just after the instance creation, the Kubernetes config file is imported, you'll just have to give it to students so they can immediatly work with.

## Pré-requisites

What you need to follow this tutorial is:

- an [OVHcloud account](https://docs.ovh.com/gb/en/customer/create-ovhcloud-account).

- an [OVHcloud PCI project](https://docs.ovh.com/gb/en/public-cloud/create_a_public_cloud_project).

- a shell with [Bash](https://www.gnu.org/software/bash) installed.

- an installed and configured [Openstack](https://www.openstack.org) client.

- an installed [Terraform](https://www.terraform.io) client.

 > To install and setup Openstack and Terraform clients, just follow the [Starting Pack to manage your OVHcloud Services from shell](../../basics/README.md) tutorial.

- a full configured `ovhrc` file with your parameters.

### SSH keypair for admin

Create a keypair named **keypairAdmin**, or choose a different name in your openstack project, this is for adding your SSH public key into the instances.

Be sure you have your private and public keys into your `$HOME/.ssh` directory, this keys will be use by Ansible.

## Create Lab Instances

### Lab Instances parameters

Open the `properties` files and modify variables with desired values.

example:
```bash
export imageName="Ubuntu 22.04"
export flavorName="b2-7"
export nbInstances=3
```

Save and exit file.

### Create the lab instances

Execute the `createInstances.sh` script.

This will loop from 1 to your instance number for creating instances.

The instance names will be formatted like **k3s[0-9][0-9][0-9]**.

For each instance, an Ansible set of tasks will install K3s and then return the Kubernetes config file, formatted like **config-k3s[0-9][0-9][0-9]**

## Tests

### Test instances creation

List instances

```bash
openstack server list
```

Result should be like this:
```bash
+--------------------------------------+---------+--------+------------------------------------------------+--------------+--------+
| ID                                   | Name    | Status | Networks                                       | Image        | Flavor |
+--------------------------------------+---------+--------+------------------------------------------------+--------------+--------+
| 149327d1-37bb-4828-8eb6-dff25e226cef | k3s009  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| 77c4581f-9470-4ab3-a12f-6a1950bd78df | k3s002  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| 7cbd5747-3c78-4282-9ec8-52549f5edf97 | k3s007  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| c7059c17-467a-4906-b023-e74df66e04a3 | k3s008  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| 41f2be0e-f41a-4a51-a389-a9163913f971 | k3s011  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| b259d0b0-775b-4cc5-832b-f88231c5b6dc | k3s019  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| e45a26dd-4e6c-4765-a318-573941ab9638 | k3s010  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| 53c51b0c-9072-4e25-9aa1-9204ebfd4ddc | k3s021  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| ca791f65-13d1-4ffe-9751-594552310fc0 | k3s016  | ACTIVE | Ext-Net=XXXX:YYYY:ZZZ:UUU::AAA, AA.BBB.LL.AAA  | Ubuntu 22.04 | b2-7   |
| d2bbb14e-3390-4504-9f73-dcdd4e344175 | k3s004  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| f3fbb5d4-8b5f-465c-98bc-3ceed7ba3104 | k3s018  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 68f98435-d6bd-42cd-bcd9-c3afe5337ad8 | k3s013  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| b8be9258-060b-420d-9331-bdab8374a5d4 | k3s001  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| d46821b3-c30d-4828-ae44-dc1c321602f0 | k3s012  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 4ae4ffce-7f86-4175-b0b2-efd935c4ed66 | k3s028  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| d91af995-7436-4816-93b3-cd943a2709d1 | k3s005  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| ef4cec07-5be6-4567-b65d-0dc99b57e937 | k3s026  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| eb71bd0a-7ff3-4594-a372-9cc51ab241f0 | k3s006  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 241202bf-5a76-4324-94f2-4f07e7beb0f1 | k3s003  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 87c0a140-3111-440a-a7ad-6602d621b75e | k3s027  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 18149170-4074-4683-9813-655be5d4b43f | k3s015  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 254f921e-40ad-4243-ab1e-7944f82680c4 | k3s014  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 6769cd46-0d7c-430a-8ade-4bdd506578ff | k3s020  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 6c0ae6c0-7c37-4173-9cc5-e59c92f3d241 | k3s025  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 96c517e5-b7fb-4577-93b5-a70df968ce38 | k3s022  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| a7e1282e-6ddb-47ef-a5c4-8d7764ef80d1 | k3s024  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| cb0905f2-ee1e-4817-a0e7-429efe543690 | k3s030  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| d67132ab-b9a8-4df4-95ef-91026af83773 | k3s023  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 432d8877-0ff2-4512-ab84-389c21a992a0 | k3s029  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
| 9a7b68f4-274d-4f05-81e9-3001d444ab81 | k3s017  | ACTIVE | Ext-Net=VV.OOO.LL.AAA, XXXX:YYYY:ZZZ:UUU::AAA  | Ubuntu 22.04 | b2-7   |
+--------------------------------------+---------+--------+------------------------------------------------+--------------+--------+
```

### Test K3s 

From the Kubernetes generated config files list, choose one and test the K3s access with the kubectl tool:

```bash
export KUBECONFIG=./config-k3s014 && kubectl get ns
```

Result should be like this:

```bash
NAME              STATUS   AGE
default           Active   86s
kube-system       Active   86s
kube-public       Active   86s
kube-node-lease   Active   86s
```

## Delete Lab Instances

To delete all instances, simply launch the [deleteInstances.sh] script.

This will use the terrafomr destroy command, and delete all kubernetes config files.

## Import Instances

You lose the Terrafomr plan? No problem, the [import.sh] will recover all the **k3s[0-9][0-9][0-9]** instances for you.
