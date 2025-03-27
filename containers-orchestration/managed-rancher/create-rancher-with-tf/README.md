## Create a Managed Rancher Service with Terraform

### General information
 - 🔗 [Using Terraform with OVHcloud](https://help.ovhcloud.com/csm/fr-terraform-at-ovhcloud?id=kb_article_view&sysparm_article=KB0054776)
 - 🔗 [How to use Terraform](https://help.ovhcloud.com/csm/en-gb-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050787)
  - 🔗 [Getting started with Managed Rancher Service](https://help.ovhcloud.com/csm/en-gb-public-cloud-managed-rancher-service-getting-started?id=kb_article_view&sysparm_article=KB0061909)
 - 🔗 [ovh_cloud_project_rancher](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_rancher)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

### Set up
  - Install the [Terraform CLI](https://www.terraform.io/downloads.html)
  - Get the credentials from the OVHCloud Public Cloud project:
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)

### Demo
  - set the environment variables `OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET`, `OVH_CONSUMER_KEY` and `OVH_CLOUD_PROJECT_SERVICE`

```bash
# OVHcloud provider needed keys
export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="xxx"
export OVH_APPLICATION_SECRET="xxx"
export OVH_CONSUMER_KEY="xxx"
export OVH_CLOUD_PROJECT_SERVICE="xxx"
```
  - Replace the value of your OVH_CLOUD_PROJECT_SERVICE environment variable in the [variables.tf](variables.tf) file (in the project_id variable)

`envsubst < variables.tf.template > variables.tf`

  - use the [rancher.tf](rancher.tf) file to define the resources to create
  - use the [output.tf](output.tf) file to display the URL and the information of the Rancher to display at the end of Terraform execution
  - run the `terraform init` command
  - run the `terraform plan` command
  - run the `terraform apply` command (~ several seconds)
  - get the Rancher value:

```bash
terraform output rancher_url
terraform output rancher_password
```

Note: you can run the `create.sh` script instead of executing each previous commands manually ;-)

### Destroy

  - destroy the cluster: `terraform destroy`

Note: you can run the `destroy.sh` script instead of executing the previous command manually ;-)


### After the demo

  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-