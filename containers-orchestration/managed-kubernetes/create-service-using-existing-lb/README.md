## Create a LB with TF and use it in a MKS service

/!\ Warning: works only on MKS Standard for th emoment!

MKS Standard -> call directly to the CCM (100% upstream)
MKS Free -> PCI Integration problem (to be fixed)

### General information
 - 🔗 [Using Terraform with OVHcloud](https://help.ovhcloud.com/csm/fr-terraform-at-ovhcloud?id=kb_article_view&sysparm_article=KB0054776)
 - 🔗 [How to use Terraform](https://help.ovhcloud.com/csm/en-gb-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050787)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

### Prerequisites
 - Have an existing MKS Standard (on EU-WEST-PAR)

### Set up
  - Install the [Terraform CLI](https://www.terraform.io/downloads.html)
  - Get the credentials from the OVHCloud Public Cloud project:
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)
  - Install the kubectl CLI

### Demo

#### Load Balancer creation

  - set the environment variables `OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET`, `OVH_CONSUMER_KEY` and `OVH_CLOUD_PROJECT_SERVICE`

```bash
# OVHcloud provider needed keys
export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="xxx"
export OVH_APPLICATION_SECRET="xxx"
export OVH_CONSUMER_KEY="xxx"
export OVH_CLOUD_PROJECT_SERVICE="xxx"
```

  - replace the service_name in the [variables.tf](variables.tf) file

```bash
envsubst < variables.tf.template > variables.tf
```

  - (If necessary) change the region in the [variables.tf](variables.tf) file (EU-WEST-PAR by default)

  - use the [lb.tf](lb.tf) file to define the resources to create
  - use the [output.tf](output.tf) file to display the LB ID at the end of Terraform execution

  - run the `terraform init` command
  - run the `terraform plan` command
  - run the `terraform apply` command (~ 2-3 mins)

  - retrieve the Load Balancer ID (and save it in an environment variable)

```bash
export LB_ID=$(terraform output lb_id)
echo $LB_ID
```

#### Deploy an application in a deployment and its service attached to the exiting LB

/!\ To do on an MKS Standard!!

  - deploy a deployment

```bash
cd k8s
kubectl create ns demo-attach-ip
kubectl apply -f deployment.yaml -n demo-attach-ip
```

  - replace the value of your LB_IP environment variable in the `svc.yaml` file (in the annotation):

```bash
envsubst < svc.yaml.template > svc.yaml
```

  - deploy a service of type LB attached to the existing LB

```bash
kubectl apply -f svc.yaml -n demo-attach-ip
```

  - check the service is atatched to the LB (and have an external IP):

```bash
kubectl get deploy,svc -n demo-attach-ip
```

Note please wait several seconds to obtain the EXTERNAL-IP


### After the demo

  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-
