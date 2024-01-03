# Deploy a Wordpress website and Mysql DB with Terraform

The purpose of this tutorial is to create a Mysql database and a Wordpress website and link them together in a Kubernetes cluster.

We will divide the project into two layers. The first layer is used to deploy the cluster and fetch the nodes. The second layer is used to deploy the services. Each layer is executed one by one.

![Infrastructure diagram](./img/diagram.png)

## Requirements

You need the following:
* [Terraform](https://www.terraform.io/) installed
* [curl](https://curl.se/) installed
* an [OVHcloud Public cloud project](https://www.ovhcloud.com/en/public-cloud/)
* OVHcloud API credentials
    * [EU](https://www.ovh.com/auth/?onsuccess=https%3A%2F%2Fwww.ovh.com%2Fauth%2FcreateToken%2F%3F)
    * [CA](https://ca.ovh.com/auth/?onsuccess=https%3A//ca.ovh.com%2Fauth%2FcreateToken%2F%3F)
* [OpenStack credentials](https://help.ovhcloud.com/csm/en-public-cloud-compute-set-openstack-environment-variables?id=kb_article_view&sysparm_article=KB0050920)

## Set the environment variables

```bash
# OVHcloud provider needed keys
export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="xxx"
export OVH_APPLICATION_SECRET="xxx"
export OVH_CONSUMER_KEY="xxx"
export OVH_CLOUD_PROJECT_SERVICE="xxx"

# OpenStack credentials
export OS_AUTH_URL=https://auth.cloud.ovh.net/v3
export OS_TENANT_NAME="11111111111"
export OS_USERNAME="user-xxxxxxxx"
export OS_PASSWORD="xx"
export OS_REGION_NAME="XX"
```

### Layer 1 : kube

* Deployment of a managed Kubernetes cluster with its node-pool

### Layer 2 : db & wordpress

* Deployment of a managed MySQL DB with its OVHcloud user
* IP restriction on DBs
* Deployment of a Wordpress website with Helm
* Interconnection of the DB and the website

### Configuration files

* provider.tf      : Contains the providers
* main.tf          : Contains the ressources and datasources 
* variables.tf     : Contains the variables we need to declare
* variables.tfvars : Contains the value of the variables
* output.tf        : Contains the output we want
* backend.tf       : Create the backend for the layering

### Variables

|Variable name        |Variable parameter   |Parameter description|
|---------------------|---------------------|---------------------|
|kubernetes|region|Region of the Kubernetes cluster|
|database|region|Region of the database|
|database|plan|Plan of the cluster|
|database|flavor|A valid OVHcloud public cloud database flavor name|
|database|version|The version of the engine in which the service should be deployed|

## Build and run

### Create the Terraform variables file (configuration)

Create the Terraform variables configuration file and fill the needed informations.

```bash
vi variables.tfvars

database = {
    region       = "DE"
    plan         = "essential"
    flavor       = "db1-7"
    version      = "8"
}

kubernetes = {
    region = "DE"
}
```

### Validate the configuration - 01-kube

```bash
cd 01-kube
terraform init
terraform plan -var-file=../variables.tfvars
```

### Create the cluster and the nodes-pool - 01-kube

```bash
terraform apply -var-file=../variables.tfvars -auto-approve
```

### Validate the configuration - 02-db-wordpress

```bash
cd ../02-db-wordpress
terraform init
terraform plan -var-file=../variables.tfvars
```

### Create the DB, website and the monitoring services - 02-db-wordpress

```bash
terraform apply -var-file=../variables.tfvars -auto-approve
```

### Export the credentials

If you need to re-use the credentials in other scripts, you can export the user credentials and the URI

```bash
export PASSWORD=$(terraform output -raw user_password)
export USER=$(terraform output -raw user_name)
export URI=$(terraform output -raw cluster_uri)
```

With these exports you can go directly in any other example (e.g: go) to docker build and run it and see it working.

### Delete the DB and the cluster

```bash
cd 02-db-wordpress
terraform destroy -var-file=../variables.tfvars -auto-approve
cd ../01-kube
terraform destroy -var-file=../variables.tfvars -auto-approve
```