# Block Storage Classic Multiattach with OCFS2

## General information

OVHcloud provides a Block storage of type classic-multiattach in all the 3AZ regions. This type of volume replicate the data in each zone and you can attach the volume to multiple instances at the same time. With this type of volume it is recommanded to use a file system like OCFS2 to avoid data corruption.

⚠️ A Gateway is needed because of the Floating IP used by one of the compute Instance in this example.

After applying this Terraform example you will have:

* A private network
* A gateway
* Three instances (one in each AZ)
* A volume classic multiattach attached to the 3 instances
* A floating IP attached to one of the instances (to be able to SSH into the private network)

## Configure the deployment
### Configure the Terraform providers

[How to use Terraform](https://help.ovhcloud.com/csm/en-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050797)

## Customize the deployment

Configure Terraform with your SSH public key:

```
vim terraform.tfvars
```

```
ssh_public_key = "<your_ssh_public_key>"
```

Configure the VLAN used by the private network if needed (default VLAN: 11):

```
private_network_vlan_id = "<your_vlan_id>"
```

## Deploy

```
terraform init
terraform plan
terraform apply
```

## Verify the data is replicated across zones

```
ssh -A ubuntu@<instance_1_public_ip>
```

```
cd /mnt
sudo touch test
ssh <instance_2_private_ip>
ls /mnt
```
