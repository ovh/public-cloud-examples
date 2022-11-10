# Create instances with K3s installed on OVHcloud Public Cloud

This is how to create many instances with [K3s](https://k3s.io/), a lightweight Kubernetes, installed on.

Just after the instance creation, the Kubernetes config file is imported, you'll just have to give it to students so they can immediatly work with.

## Pré-requisites

### Openstack configuration file

We use Openstack to get instances Ids.

Import the appropriate openrc file at he root of this project.

> Using Gitpod ? Create a variable named **OS_OPENRC_B64**, with the base64 encoded content of the file. The openrc file will be automaticly created with right content.

### SSH keypair for admin

Create a keypair named **keypairAdmin**, or choose a different name in your openstack project, this is for adding your SSH public key into the instances.

Be sure you have your private and public keys into your **$HOME/.ssh** directory, this keys will be use by Ansible.

> Using Gitpod ? Create a couple of variables named **SSH_PUB_B64** and **SSH_PV_B64**, with respectivly the base64 encoded content of yout SSH public and private keys. The workspace will be created with your provided SSH keys in the $HOME/.ssh directory, and the **TF_VAR_keypairAdmin** variable will be automaticly setted.

### Create OVHcloud API token

This token are used by the OVHcloud Terraform provider.

Go to [this page](https://www.ovh.com/auth/api/createToken) to create and save your token.

### Terraform configuration file

We use Terraform to instanciate instances and then launch Ansible post-creation K3s setup tasks.

Create a terraformrc file at the root of this project like this:

```bash
export OVH_ENDPOINT=ovh-eu
export OVH_APPLICATION_KEY=
export OVH_APPLICATION_SECRET=
export OVH_CONSUMER_KEY=
export TF_VAR_IP=xx.xx.xx.xx/32
export TF_VAR_serviceName=
export TF_VAR_keypairAdmin="xxxxxx"
```

The **OVH_APPLICATION_KEY**, **OVH_APPLICATION_SECRET** and **OVH_CONSUMER_KEY** values come from your OVHcloud API token.

The **TF_VAR_IP** value is the IP address of your machine.

The **TF_VAR_serviceName** is the Id of your OVHcloud Public Cloud project (find by requesting the API at /cloud/project)

The **TF_VAR_keypairAdmin** is the name of your Openstack keypair

> Using Gipod ? Create the 3 variables **OVH_API_AK_b64**, **OVH_API_AS_b64** and **OVH_API_CK_b64** with the base6' encoded content of your OVHcloud Api token. The terraformrc file will be automaticly created with right content.

## Create Lab Instances

### Specify how many instances you want

Open the **createInstances.sh** script and insert the desired value into the **nb** variable.

example:
```bash
# nb --> how many instances you want to create
nb=30
```

Save and exit script.


### Create the lab instances

Execute the **createInstances.sh** script.

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
