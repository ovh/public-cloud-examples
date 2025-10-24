# File Storage as a Service on OVHcloud Public Cloud

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

## Deploy

```
terraform init
terraform plan
terraform apply
```

## Verify the share is mounted

```
ssh ubuntu@<instance_ip>
```

```
df -h /mnt/share
Filesystem                                                   Size  Used Avail Use% Mounted on
10.0.0.4:/shares/share-cf845f66-ca59-4ee3-ba3d-97a63a8f300e  9.8G  2.0M  9.3G   1% /mnt/share
```