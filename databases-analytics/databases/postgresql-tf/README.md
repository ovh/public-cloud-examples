## Create PostgreSQL Database with Terraform

### General information
 - 🔗 [Using Terraform with OVHcloud](https://help.ovhcloud.com/csm/fr-terraform-at-ovhcloud?id=kb_article_view&sysparm_article=KB0054776)
 - 🔗 [Find out how to order and manage your Public Cloud managed database service using Terraform ](https://help.ovhcloud.com/csm/fr-public-cloud-databases-order-terraform?id=kb_article_view&sysparm_article=KB0048840)  
 - 🔗 [How to use Terraform](https://help.ovhcloud.com/csm/en-gb-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050787)
 - 🔗 [cloud_project_database](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_database)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)
 - 🔗 [public-cloud-databases-examples](https://github.com/ovh/public-cloud-databases-examples)

### Set up
  - Install the [Terraform CLI](https://www.terraform.io/downloads.html)
  - Get the credentials from the OVHCloud Public Cloud project:
    - `endpoint`
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)

### Demo
  - set the environment variables `OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET`, `OVH_CONSUMER_KEY` and `OVH_CLOUD_PROJECT_SERVICE`
  - replace the placeholder `<your ip here>` (see https://whatismyipaddress.com/)
  - use the [my-ovh_postgresql_db.tf](my-ovh_postgresql_db.tf) file to define the resources to create
  - use the [output.tf](output.tf) file to display the PG informations (user, ...) at the end of Terraform execution
  - run the `terraform init` command
  - run the `terraform plan -var="local_authorised_ip=<your IP>/32"` command
  - run the `terraform apply -var="local_authorised_ip=<your IP>/32` command (~ 10 mins)
  - get the `outputs` value for the password: `terraform output -raw user_password`
  - test the connexion to the DB
  - destroy the PostgreSQL: `terraform destroy -var="local_authorised_ip=<your IP>/32`


### After the demo
  - if needed, delete the credential with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-