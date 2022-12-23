# S3 bucket
This example builds an S3 bucket within OVHcloud Public Cloud.

The components that will be created are : 

- [S3 Object storage](https://www.ovhcloud.com/en/public-cloud/object-storage/).

## Pre-requisites

You need to follow steps from the [basics tutorial](../../basics/README.md) for having necessary tools and a fonctionnal `ovhrc` file.
However for the following example, since openstack is not used, you  need only terraform provider OVH API environment variables and the public cloud project id (serviceName variable in the tutorial). 

## properties files

Edit the `variables.auto.tfvars` file to modify values if needed:

```terraform
// region as described in https://docs.ovh.com/gb/en/storage/object-storage/s3/location/
region = "gra"

// S3 endpoint as described in https://docs.ovh.com/gb/en/storage/object-storage/s3/location/
s3_endpoint = "https://s3.gra.io.cloud.ovh.net"

// Bucket name prefix
bucket_name_prefix="tf-s3-bucket"
```

## Create

Create the bucket with this commands:

```bash
source ovhrc
terraform init
terraform plan
terraform apply
```

Or simply use the `createBucket.sh` script.

```bash
./createBucket.sh
```


## Delete / Purge

Clean you environment with this commands:

```bash
source ovhrc
terraform destroy --auto-approve
```

Or execute the `deleteBucket.sh` script:

```bash
./deleteBucket.sh
```
