# Starting Pack to manage your OVHcloud Services from shell

In this tutorial, you will learn how to install, setup and use tools to manage [OVHcloud services](https://www.ovhcloud.com).

- [OVHcloud API](https://api.ovh.com) Bash script

- [Openstack](https://www.openstack.org)

- [Terraform](https://www.terraform.io)

- [kubectl](https://kubernetes.io/docs/tasks/tools)

- [Ansible](https://www.ansible.com)

## Pre-requisites

What you need to follow this tutorial is:

- an [OVHcloud account](https://docs.ovh.com/gb/en/customer/create-ovhcloud-account).

- an [OVHcloud PCI project](https://docs.ovh.com/gb/en/public-cloud/create_a_public_cloud_project).

- a shell with [Bash](https://www.gnu.org/software/bash) installed.

## Configuration file

All necessary variables are stored in the `ovhrc` files. Copy and paste the `ovhrc.template` file to create yours.

```bash
cp ovhrc.template ovhrc
```

Now you have to add values to variables.

### Variables from openstack openrc file

The first part of the `ovhrc` file is dedicated to the openstack cli.

You must follow the tutorial [Creating and deleting OpenStack users](https://docs.ovh.com/gb/en/public-cloud/creation-and-deletion-of-openstack-user) to create an openstack user, and the step 1 [Retrieve the variables] of the tutorial [Setting OpenStack environment variables](https://docs.ovh.com/gb/en/public-cloud/set-openstack-environment-variables) to get the associated `openrc` file.

```bash
#### Openstack vars from openrc file
export OS_AUTH_URL=https://auth.cloud.ovh.net/v3
export OS_IDENTITY_API_VERSION=3
export OS_USER_DOMAIN_NAME=${OS_USER_DOMAIN_NAME:-"Default"}
export OS_PROJECT_DOMAIN_NAME=${OS_PROJECT_DOMAIN_NAME:-"Default"}
export OS_TENANT_ID=""
export OS_TENANT_NAME=""
export OS_USERNAME=""
export OS_PASSWORD=""
export OS_REGION_NAME=""
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi
```

### Variables from the OVHcloud API token

The second part of the `ovhrc` file is for accessing the [OVHcloud API](https://api.ovh.com).

The `OVH_ENDPOINT` and `OVH_BASEURL` variables depends on your location.

The `OVH_CLOUD_PROJECT_SERVICE` must be setted with the Openstack service is, known in the openrc file as `OS_TENANT_ID`. This variable is mainly used by the OVHcloud Terraform provider.

Get the other variables values by following the first step of the [First Steps with the OVHcloud APIs](https://docs.ovh.com/gb/en/api/first-steps-with-ovh-api) tutorial.

```bash
#### OVH API vars from OVHcloud manager
export OVH_ENDPOINT=""
export OVH_BASEURL=""
export OVH_APPLICATION_KEY=""
export OVH_APPLICATION_SECRET=""
export OVH_CONSUMER_KEY=""
export OVH_CLOUD_PROJECT_SERVICE="$OS_TENANT_ID"

### OVHcloud API endpoints
#   OVH_ENDPOINT        :       OVH_BASEURL
#   ovh-eu              :       https://eu.api.ovh.com/1.0/
#   ovh-us              :       https://api.us.ovhcloud.com/1.0/
#   ovh-ca              :       https://ca.api.ovh.com/1.0/
#   kimsufi-eu          :       https://eu.api.kimsufi.com/1.0/
#   kimsufi-ca          :       https://ca.api.kimsufi.com/1.0/
#   soyoustart-eu       :       https://eu.api.soyoustart.com/1.0/
#   soyoustart-ca       :       https://ca.api.soyoustart.com/1.0/
```

### Load variables into your environemnt

Now your `ovhrc` is ready, load its content into your environment:

```bash
. ovhrc
```

## Install necessary tools

### openstack cli / jq / curl

Follow the [Install the OpenStack command-line clients](https://docs.openstack.org/newton/user-guide/common/cli-install-openstack-command-line-clients.html) tutorial to install the openstack cli.

The command-line JSON processor [jq](https://stedolan.github.io/jq) and the [curl](https://curl.se) command-line http tool are needed too.

Example on an Ubuntu/Debian system:

```bash
sudo apt update && sudo apt -y install \
    gettext \
    jq \
    python3-aodhclient \
    python3-barbicanclient \
    python3-ceilometerclient \
    python3-cinderclient \
    python3-cloudkittyclient \
    python3-designateclient \
    python3-gnocchiclient \
    python3-octaviaclient \
    python3-osc-placement \
    python3-openstackclient \
    python3-pankoclient \
    python3-pip \
    python3-venv \
    zip \
    gnupg \
    software-properties-common \
    curl
```


<details><summary> 📍 Example : Request the network list</summary>


```bash
openstack network list
```

The result should be like:

```bash
+--------------------------------------+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| ID                                   | Name              | Subnets                                                                                                                                                                                                                                                                  |
+--------------------------------------+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| xxxxxxxx-ffdf-40f6-9722-xxxxxxxxxxxx | Ext-Net           | xxxxxxxx-1113-4d4f-98de-xxxxxxxxxxxx, xxxxxxxx-88e9-4e94-ac8b-xxxxxxxxxxxx, xxxxxxxx-1b86-48f3-8596-xxxxxxxxxxxx, xxxxxxxx-d5cd-4e25-b14b-xxxxxxxxxxxx, xxxxxxxx-dbed-4628-a029-xxxxxxxxxxxx, xxxxxxxx-c441-4678-b395-xxxxxxxxxxxx, xxxxxxxx-ef1d-4881-98c7-xxxxxxxxxxxx |
+--------------------------------------+-------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

</details>


### OVHcloud API bash script

The `utils/ovhAPI.sh` is a bash script that helps you to request the [OVHcloud API](https://api.ovh.com).

<details><summary> 📍 Example : Get your PCI private networks list</summary>

```bash
utils/ovhAPI.sh GET /cloud/project/${OS_TENANT_ID}/network/private |jq
```

Result:

```json
[
  {
    "id": "pn-xxxxxx_20",
    "name": "xxxxxNw",
    "vlanId": 20,
    "regions": [
      {
        "region": "GRA9",
        "status": "ACTIVE",
        "openstackId": "xxxxxxxx-1652-4eea-ad19-xxxxxxxxxxxx"
      }
    ],
    "type": "private",
    "status": "ACTIVE"
  },
  {
    "id": "pn-xxxxxx_2",
    "name": "my-private-nw",
    "vlanId": 2,
    "regions": [
      {
        "region": "GRA11",
        "status": "ACTIVE",
        "openstackId": "xxxxxxxx-2c7a-4e56-bef9-xxxxxxxxxxxx"
      }
    ],
    "type": "private",
    "status": "ACTIVE"
  }
]
```

</details>

<details><summary> 📍 Example : Get the PCI private network id from its name, using jq</summary>

```bash
utils/ovhAPI.sh GET /cloud/project/${OS_TENANT_ID}/network/private | jq -r '.[] | select(.name=="my-private-nw") |.id'
```

Result:

```bash
pn-xxxxxx_2
```

</details>

<details><summary> 📍 Example : Change your PCI account description</summary>

```bash
# Create a data JSON file.
cat << 'EOF' > data.json
{
  "description": "My_PCI_Project",
  "manualQuota": false
}
EOF

utils/ovhAPI.sh POST /cloud/project/${OS_TENANT_ID} $(jq -c . < data.json)
```

Result:

```bash
null
```

the `null` response means it's OK.

Check the new description with:

```bash
utils/ovhAPI.sh GET /cloud/project/${OS_TENANT_ID} | jq .description
```

Result:

```bash
"My_PCI_Project"
```

</details>

### terraform cli

Install Terraform by following the [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) tutorial.

Example on an Ubuntu/Debian system:

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
```

Test the Terraform setup:

```bash
cd terraform
terraform init
```

Result:

```bash
Initializing the backend...

Initializing provider plugins...
- Finding latest version of ovh/ovh...
- Finding terraform-provider-openstack/openstack versions matching "~> 1.35.0"...
- Installing ovh/ovh v0.22.0...
- Installed ovh/ovh v0.22.0 (signed by a HashiCorp partner, key ID F56D1A6CBDAAADA5)
- Installing terraform-provider-openstack/openstack v1.35.0...
- Installed terraform-provider-openstack/openstack v1.35.0 (self-signed, key ID 4F80527A391BEFD2)

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

<details><summary> 📍 Example : Create a SSH Keypair</summary>

```bash
cat << 'EOF' > keypair.tf
resource "openstack_compute_keypair_v2" "myKeypair" {
  name       		= "myKeypair"
  public_key 		= "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxW9O0o0ENkVJ19/KFD33NYDtC1arT4u2aUl4heuKmAfrLrZUQvVQMuST50YHwlJSy9LVtnsRxZiFyI/xyTMmtPQ+oIOWMkQyuNlONcQHKtMNPa1P/Q8h2362A6eN7UB5z6qDSin+k/RkwnkypEi1I5AWQiZdxrT9RqdzHINHn0DdJPcJB93ZMp3c1pUhTpGXW1xq7JbFBlTeUgCJV+eSz+eVbMfgFWnU8M8exzMbxUCSGxhIaYrAXYeEp Generated-by-Nova"
}
EOF

terraform init
terraform apply
```

Result:

```bash
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # openstack_compute_keypair_v2.myKeypair will be created
  + resource "openstack_compute_keypair_v2" "myKeypair" {
      + fingerprint = (known after apply)
      + id          = (known after apply)
      + name        = "myKeypair"
      + private_key = (known after apply)
      + public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxW9O0o0ENkVJ19/KFD33NYDtC1arT4u2aUl4heuKmAfrLrZUQvVQMuST50YHwlJSy9LVtnsRxZiFyI/xyTMmtPQ+oIOWMkQyuNlONcQHKtMNPa1P/Q8h2362A6eN7UB5z6qDSin+k/RkwnkypEi1I5AWQiZdxrT9RqdzHINHn0DdJPcJB93ZMp3c1pUhTpGXW1xq7JbFBlTeUgCJV+eSz+eVbMfgFWnU8M8exzMbxUCSGxhIaYrAXYeEp Generated-by-Nova"
      + region      = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

openstack_compute_keypair_v2.myKeypair: Creating...
openstack_compute_keypair_v2.myKeypair: Creation complete after 1s [id=myKeypair]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```

You can check if the key exists with openstack cli too:

```bash
openstack keypair list
```

Result:

```bash
+-----------------+-------------------------------------------------+
| Name            | Fingerprint                                     |
+-----------------+-------------------------------------------------+
| myKeypair       | db:8c:2e:62:xx:xx:xx:xx:xx:c9:1c:a6:a9:06:05:82 |
+-----------------+-------------------------------------------------+
```

</details>

## Install additionnaly useful tools

### Ansible

Install `ansible` by following the [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) tutorial.

Example on an Ubuntu/Debian system:

```bash
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt update && sudo apt install -y ansible
```

### Kubectl

Install the Kubernetes command-line tool `kubectl` by following the first step of the [Install Tools](https://kubernetes.io/docs/tasks/tools) tutorial.

Example on an Ubuntu/Debian system:

```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
        && sudo mv ./kubectl /usr/local/bin/kubectl \
        && sudo chmod 0755 /usr/local/bin/kubectl
```

<details><summary> 📍 Example : Get an existing Managed Kubernetes config file with the OVHcloud API and use the kubectl tool</summary>

Get your Managed Kubernetes service id with this command:

```bash
utils/ovhAPI.sh GET /cloud/project/${OS_TENANT_ID}/kube
```

Then get the associated config file:

```bash
utils/ovhAPI.sh POST /cloud/project/${OS_TENANT_ID}/kube/xxxxxxxx-9241-4a9e-86ba-xxxxxxxxxxxx/kubeconfig | jq -r .content > mykubeconfig
```

Test the kubectl Managed Kubernetes cluster access:

```bash
export KUBECONFIG=./mykubeconfig
kubectl get ns
```

Result:

```bash
NAME              STATUS   AGE
default           Active   8d
ingress-nginx     Active   8d
kube-node-lease   Active   8d
kube-public       Active   8d
kube-system       Active   8d
logging           Active   8d
monitoring        Active   8d
```

</details>

## Go further

Now you can access and manage all [OVHcloud products](https://docs.ovh.com/gb/en) from your shell and start scripting useful tools.

Feel free to propose new tools or differents ways to manage our services.
