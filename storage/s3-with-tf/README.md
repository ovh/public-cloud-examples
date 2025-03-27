# Create a simple Object Storage container (S3™ compatible bucket)

The aim of this example is to deploy two Object Storage containers. One in 1-AZ region and one in 3-AZ regon.

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
  - Replace the value of your OVH_CLOUD_PROJECT_SERVICE environment variable in the [variables.tf](variables.tf) file (in the service_name variable)

`envsubst < variables.tf.template > variables.tf`

To define the region of your containers (depending on our needs), follow this guide:
https://help.ovhcloud.com/csm/en-gb-public-cloud-storage-s3-location?id=kb_article_view&sysparm_article=KB0047382

And then update the regions variables in the `variables.tf` file.

/!\ The region must be in uppercase!

Run the TF command `terraform apply`:
```bash
$ terraform apply
```

To destroy the bucket with all the objects inside, run the command `terraform destroy`.

For more information about object container storage you can read the [OVHcloud documentation](https://help.ovhcloud.com/csm/en-ie-documentation-storage-object-storage?id=kb_browse_cat&kb_id=38e74da5a884a950f07829d7d5c75217&kb_category=b29021c8e5a5edd0f078850a25104df8&spa=1).