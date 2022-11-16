# Starting Pack to manage your OVHcloud Services from shell

In this tutorial, you will learn how to install and setup tools you need to manage [OVHcloud services](https://www.ovhcloud.com), as [OVHcloud API](https://api.ovh.com), [Openstack](https://www.openstack.org), [Terraform](https://www.terraform.io) and [Ansible](https://www.ansible.com).

## Pre-requisites

What you need to follow this tutorial is:

- an [OVHcloud account](https://docs.ovh.com/gb/en/customer/create-ovhcloud-account).

- an [OVHcloud PCI project](https://docs.ovh.com/gb/en/public-cloud/create_a_public_cloud_project).

- a shell with [Bash](https://www.gnu.org/software/bash) installed.

## Configuration file

All needed variables are stored in the `ovhrc` files. Copy and paste the `ovhrc.template` file to create yours.

```bash
cp ovhrc.template ovhrc
```

Now you have to add needed values to variables.

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

Get the other variables values by following the first step of the [First Steps with the OVHcloud APIs](https://docs.ovh.com/gb/en/api/first-steps-with-ovh-api) tutorial.

```bash
#### OVH API vars from OVHcloud manager
export OVH_ENDPOINT=""
export OVH_BASEURL=""
export OVH_APPLICATION_KEY=""
export OVH_APPLICATION_SECRET=""
export OVH_CONSUMER_KEY=""

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

### Helpers variables used by terraform cli

The last part contains helpful variables that will be used (or not) by the terraform client.

```bash
### Terraform helpers variables
export TF_VAR_IP="$(curl -s ifconfig.me)/32"
export TF_VAR_serviceName="$OS_TENANT_ID"
export TF_VAR_keypairAdmin="" # The ready to deployed SSH public key content
```

- `TF_VAR_IP` is filled with your public IP. This can helps you if you have to add your public IP address into an IP restriction list, to access to managed databases for example. If you don't want to use curl or send a http request, just add the desired value.

- `TF_VAR_serviceName` is the openstack project id, used in terraform by the OVHcloud and Openstack providers.

- `TF_VAR_keypairAdmin` is the content of a SSH public key that you want to deploy to instances that are created with terraform, and mainly necessary by Ansible.

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
    zip \
    gnupg \
    software-properties-common \
    curl
```

Test the openstack cli setup, by requesting the network list:

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

### OVHcloud API bash script

The `ovhAPI.sh` is a bash script that helps you to request the [OVHcloud API](https://api.ovh.com).

Examples: 

- Get your PCI private networks list:

```bash
./ovhAPI.sh GET /cloud/project/${OS_TENANT_ID}/network/private |jq
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

- Get the PCI private network id from its name, using jq:

```bash
./ovhAPI.sh GET /cloud/project/${OS_TENANT_ID}/network/private | jq -r '.[] | select(.name=="my-private-nw") |.id'
```

Result:

```bash
pn-xxxxxx_2
```

## terraform cli

## Examples

## Go further


```bash

```
