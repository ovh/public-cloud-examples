# 

## Create an Object Storage with Terraform

### General information
 - 🔗 [Using Terraform with OVHcloud](https://help.ovhcloud.com/csm/fr-terraform-at-ovhcloud?id=kb_article_view&sysparm_article=KB0054776)
 - 🔗 [How to use Terraform](https://help.ovhcloud.com/csm/en-gb-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050787)
 - 🔗 [cloud_project_storage](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_storage)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

### Set up
  - Install the [Terraform CLI](https://www.terraform.io/downloads.html)
  - For non Linux users: Install `gettext` (that included `envsubst` command):
```bash
  brew install gettext
  brew link --force gettext
```
  - Get the credentials from the OVHCloud Public Cloud project:
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)

### Demo

  - `cd object-storage-tf`

  - set the environment variables `OVH_APPLICATION_KEY`, `OVH_APPLICATION_SECRET`, `OVH_CONSUMER_KEY` and `OVH_CLOUD_PROJECT_SERVICE`

```bash
# OVHcloud provider needed keys
export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="xxx"
export OVH_APPLICATION_SECRET="xxx"
export OVH_CONSUMER_KEY="xxx"
export OVH_CLOUD_PROJECT_SERVICE="xxx"
```

  - replace the value of your OVH_CLOUD_PROJECT_SERVICE environment variable in the `variables.tf` file (in the service_name variable)

`envsubst < variables.tf.template > variables.tf`

  - use the [s3.tf](./s3.tf) file to define the resources to create
  - use the [output.tf](output.tf) file to display the bucket created at the end of Terraform execution
  - run the `terraform init` command
  - run the `terraform apply -var bucket_name=my-bucket` command

  - save the s3 user credentials in environment variables (mandatory for the following optionnal step)
```bash
export AWS_ACCESS_KEY_ID=$(terraform output -raw access_key_id)
export AWS_SECRET_ACCESS_KEY=$(terraform output -raw secret_access_key)
```

  - store the created bucket name in an environment variable (necessary for the next section).

```bash
$ export BUCKET_NAME=$(terraform output s3_bucket)
```

## Configure an OVHcloud S3-compatible Object Storage as Terraform Backend

### Demo

  - `cd ../my-app`

  - use the [backend.tf](./my-app/backend.tf.template) file to define the resources to create

  - mandatory for the `terraform init` command: replace the value of your BUCKET_NAME environment variable in the `backend.tf` file (in the bucket variable)

`envsubst < backend.tf.template > backend.tf`

  - run the `terraform init` command
