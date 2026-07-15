# Install Manila CSI on a Managed Kubernetes Sevice cluster

**Requirements:**

You need the following:
* [Terraform](https://www.terraform.io/) installed
* An [OVHcloud Public Cloud project](https://www.ovhcloud.com/en/public-cloud/)
* A [Managed Kubernetes Service cluster](https://www.ovhcloud.com/en/public-cloud/kubernetes/) that is connected to a private network

## Configure the deployment

### Configure the Terraform OVH provider

Create an OVHcloud API token:

https://api.ovh.com/createToken?GET=/\*&POST=/\*&PUT=/\*&DELETE=/\*

Configure Terraform with this token:

```bash
vim ovhrc.sh
```

```bash
export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="<your_application_key>"
export OVH_APPLICATION_SECRET="<your_application_secret>"
export OVH_CONSUMER_KEY="<your_consumer_key>"
export OVH_CLOUD_PROJECT_SERVICE="<your_public_cloud_project_ID>"
```

### Configure the Terraform OpenStack provider

Use this documentation to create an OpenStack user:
https://docs.ovhcloud.com/en/guides/public-cloud/cross-functional/create-and-delete-a-user

And this documentation to download the openrc.sh file:
https://docs.ovhcloud.com/en/guides/public-cloud/cross-functional/compute-set-openstack-environment-variables

## Customize the deployment

Configure Terraform with your OVH public cloud project id:

```bash
vim terraform.tfvars
```

```bash
service_name = "<your_public_cloud_project_id"
```

Configure Terraform with your Managed Kubernetes Cluster id:

```bash
vim terraform.tfvars
```

```bash
mks_cluster_id = "<your_mks_cluster_id>"
```

If your Managed Kubernetes Service cluster is in a 3AZ region, choose in which zone to create the share network (example: eu-west-par-a):

```bash
vim terraform.tfvars
```

```bash
share_availability_zone = "<your_share_availability_zone>"
```

## Deploy the stack

```bash
source ovhrc.sh
source openrc.sh
terraform init
terraform apply
```

## Test

Create a Persistent Volume Claim:

```bash
kubectl apply -f test/pvc.yaml
```

When the Manila share is created, create a deployment:

```bash
kubectl apply -f test/deploy.yaml
```

Verify that the pod is running:

```bash
kubectl get pod
```

Verify that you can scale the deployment (multi-attach volume):

```bash
kubectl scale deploy/nginx-deployment --replicas=2
kubectl get pod
```