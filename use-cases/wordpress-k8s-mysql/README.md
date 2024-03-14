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

* Create a private network with a [gateway](https://www.ovhcloud.com/en-gb/public-cloud/gateway/)
* Deployment of a managed Kubernetes cluster with its node-pool deployed on the private network

### Layer 2 : db & wordpress

* Deployment of a managed MySQL DB with its OVHcloud user
* IP restriction on DBs
* Deployment of a Wordpress website with Helm using [bitnami package](https://github.com/bitnami/charts/tree/main/bitnami/wordpress/1)
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

Create the 2 Terraform variables configuration files and fill the needed information.

```bash
vi variables_01.tfvars
```
Add the following for the kubernetes cluster & customize if needed
```
kubernetes = {
    region = "GRA11"
}
```

Add the following & customize if needed
```bash
vim variables_02.tfvars
```
Add the following for the kubernetes cluster & customize if needed
```
database = {
    region       = "GRA"
    plan         = "essential"
    flavor       = "db1-7"
    version      = "8"
} 
```

### Validate the configuration - 01-kube

```bash
cd 01-kube
terraform init
terraform plan -var-file=../variables_01.tfvars
```

### Create the cluster and the nodes-pool - 01-kube

```bash
terraform apply -var-file=../variables_01.tfvars -auto-approve
```

### Validate the configuration - 02-db-wordpress

```bash
cd ../02-db-wordpress
terraform init
terraform plan -var-file=../variables_02.tfvars
```

### Create the DB, website - 02-db-wordpress

```bash
terraform apply -var-file=../variables.tfvars -auto-approve
```

### Login into Wordpress 

Get the Load Balancer service IP
```bash
kubectl --kubeconfig=./kubeconfig_file get svc
```

The wordpress site is available at this IP. 

The back office is available under `/wp-admin/`. The default user is `user`, the generated password can be retrieved using :
```bash
kubectl --kubeconfig=./kubeconfig_file get secret --namespace default wordpress -o jsonpath="{.data.wordpress-password}" | base64 -d
```

### Delete the DB and the cluster

```bash
cd 02-db-wordpress
terraform destroy -var-file=../variables_02.tfvars -auto-approve
cd ../01-kube
terraform destroy -var-file=../variables_01.tfvars -auto-approve
```