# Create a simple Object container storage

To run this TF code you need to set some environment variables:
  - `AWS_SECRET_ACCESS_KEY="no_need_to_define_a_secret_key"`
  - `AWS_ACCESS_KEY_ID="no_need_to_define_an_access_key"`
> These keys are mandatory for the AWS provider but not used by our API.
  - OVHcloud API configuration:
   - OVH_APPLICATION_KEY, 
   - OVH_APPLICATION_SECRET, 
   - OVH_CONSUMER_KEY,
   - OVH_CLOUD_PROJECT_SERVICE
  - Open Stack configuration:
    - OS_AUTH_URL, 
    - OS_USERNAME, 
    - OS_PASSWORD, 
    - OS_TENANT_NAME
> See the documentation to [configure the OVHcloud provider](https://registry.terraform.io/providers/ovh/ovh/latest/docs#provider-configuration) and the [Open Stack provider](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs#configuration-reference) to set these variables.

Run the TF command `terraform apply`, you will prompt to enter the credentials:
```bash
$ terraform apply
var.access_key
  Enter a value: xxxxx
 
var.secret_key
  Enter a value: xxxxxx
```

To destroy the bucket with all the objects inside, run the command `terraform destroy`.

For more information about object container storage you can read the [OVHcloud documentation](https://help.ovhcloud.com/csm/en-ie-documentation-storage-object-storage?id=kb_browse_cat&kb_id=38e74da5a884a950f07829d7d5c75217&kb_category=b29021c8e5a5edd0f078850a25104df8&spa=1).