# Hello world for Wordpress and Mysql with Terraform

The purpose of this tutorial is to create a mysql database and a wordpress website and link them together in a Kubernetes cluster.

We will divide the project into two layers. The first layer is used to deploy the cluster and fetch the nodes. The second layer is used to deploy the services. Each layer is executed one by one.

![Infrastructure diagram](./img/diagram.png)

## Requirements

You need the following:
* [terraform](https://www.terraform.io/) installed
* an [OVHcloud Public cloud project](https://www.ovhcloud.com/en/public-cloud/)
* OVHcloud API credentials
    * [EU](https://www.ovh.com/auth/?onsuccess=https%3A%2F%2Fwww.ovh.com%2Fauth%2FcreateToken%2F%3F)
    * [CA](https://ca.ovh.com/auth/?onsuccess=https%3A//ca.ovh.com%2Fauth%2FcreateToken%2F%3F)

## Operation

### Layer 1
* Deployment of a managed kubernetes cluster with its node-pool

### Layer 2
* Deployment of a managed MySQL DB with its OVHcloud user
* IP restriction on DBs
* Deployment of a wordpress website with Helm
* Interconnection of the DB and the website

### Configuration files
* provider.tf    : Contains the providers
* main.tf        : Contains the ressources and datasources 
* variables.tf   : Contains the variables we need to declare
* secrets.tfvars : Contains the value of the variables
* output.tf      : Contains the output we want
* backend.tf     : Create the backend for the layering

### Variables

|Variable name        |Variable parameter   |Parameter description|
|---------------------|---------------------|---------------------|
|ovh|endpoint|API endpoint to use|
|ovh|application_key|API Application Key|
|ovh|application_secret|API application secret|
|ovh|consumer_key|API consumer key|
|kubernetes|project_id|Public cloud project service name|
|kubernetes|region|Region of the Kubernetes cluster|
|database|project_id|Public cloud project service name|
|database|region|Region of the database|
|database|plan|Plan of the cluster|
|database|flavor|A valid OVHcloud public cloud database flavor name|
|database|version|The version of the engine in which the service should be deployed|
|openstack|user_name|The Username to login with|
|openstack|tenant_name|The Name of the Tenant to login with|
|openstack|password|The Password to login with|
|openstack|auth_url|The Identity authentication URL|
|openstack|region|The region of the OpenStack cloud to use|

## Build and run

### Create the terraform variables file
```console
read -s APPLICATION_KEY
read -s APPLICATION_SECRET
read -s CONSUMER_KEY
read CLOUD_PROJECT_ID

cat << EOF > secrets.tfvars
ovh = {
    endpoint           = "ovh-eu"
    application_key    = "$APPLICATION_KEY"
    application_secret = "$APPLICATION_SECRET"
    consumer_key       = "$CONSUMER_KEY"
}

product = {
    project_id = "$CLOUD_PROJECT_ID"
    region     = "DE"
    plan       = "essential"
    flavor     = "db1-7"
    version    = "8"
}

access = {
    ip  = "$(curl ifconfig.me)/32"
}
EOF
```

### Validate the configuration - Layer 1

```console
terraform init
terraform plan -var-file=secrets.tfvars
```

### Create the cluster and the nodes-pool - Layer 1

```console
terraform apply -var-file=secrets.tfvars -auto-approve
```

### Validate the configuration - Layer 2

```console
terraform init
terraform plan -var-file=secrets.tfvars
```

### Create the DB, website and the monitoring services - Layer 2

```console
terraform apply -var-file=secrets.tfvars -auto-approve
```

### Export the credentials

If you need to re-use the credentials in other scripts, you can export the user credentials and the URI

```console
export PASSWORD=$(terraform output -raw user_password)
export USER=$(terraform output -raw user_name)
export URI=$(terraform output -raw cluster_uri)
```

With these exports you can go directly in any other example (e.g: go) to docker build and run it and see it working.

### Delete the cluster

```console
terraform destroy -var-file=secrets.tfvars -auto-approve
```