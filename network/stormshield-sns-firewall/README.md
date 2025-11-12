# Deploy Stormshield SNS HA cluster on Public Cloud

This Terraform automate the deployment of a Stormshield SNS HA cluster on Public Cloud.

The manual steps to achieve this are described here:
https://help.ovhcloud.com/csm/en-public-cloud-network-stormshield-vrack?id=kb_article_view&sysparm_article=KB0065106

## Requirements

* A Public Cloud project
* An additional IP block
* A vRack
* A Stormshield SNS image for OpenStack
* At least one Stormshield license with the corresponding maj file
* A SSH key
* Terraform binary
* Openstack CLI

## Configuring the deployment

* Create an OpenStack user in your Public Cloud project (Users & Roles->Add user)
* Download your user openrc file
* Load the Openstack environment variable:
    ```source openrc.sh```
    ```export OS_REGION_NAME=<REGION>```

* Add your Public Cloud project to your vRack
* Add your IP block to your vRack
    https://help.ovhcloud.com/csm/en-dedicated-servers-ip-block-vrack?id=kb_article_view&sysparm_article=KB0043342
* Upload Stormshield SNS image
    ```openstack image create --disk-format raw --container-format bare --file ./utm-SNS-EVA-4.8.11-openstack.qcow2 utm-SNS-EVA-4.8.11```

* Configure the following variables in terraform.tfvars:
    - ovh_os_instance_region:
        The region where you would like to deploy Stromshield SNS (example: SBG7).
        This needs to be the same region than where you upload your SNS image.
    - ovh_os_instance_password:
        The password for the stormshield admin user
    - ssh_public_key:
        Your SSH public key
    - admin_client_ip:
        The public IP of the machine used to administrate stormshield.
        You can use `curl ipinfo.io/ip` to get the public IP of your machine.
    - ovh_os_instance_wan_ip:
        A list of two public IP within your IP block that can be used by the two Stormshield instances.
        Only the first one will be kept as VIP for your Stormshield HA cluster.
    - ovh_os_instance_wan_mask:
        The mask of your IP block.
    - ovh_os_instance_wan_gw
        The gateway for your IP block.
    - ovh_os_instance_image_name
        The name of your Stormshield image (example: utm-SNS-EVA-4.8.11).
    - stormshield_serial_number
        Two serial numbers for your Stormshield instances (example: ["VMSNSXXXXXXXXXX", "VMSNSYYYYYYYYYYY"]).
* Add your maj files (corresponding to your stormshield_serial_number list) to the stormshield-maj directory (exemple: vminit-<serial_number>.maj)

## Deploy Stormshield SNS HA cluster

terraform init
terraform plan
terraform apply

Browse: https://<first_public_ip>
Login: admin
Password: The value of the Terraform ovh_os_instance_password variable

**note:** The Stormshield SNS configuration can take a little bit of time, therefore wait a bit before trying to login.