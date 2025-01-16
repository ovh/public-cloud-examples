# Create a simple Object container storage

To run this TF code you need to set some environment variables (mandatory for AWS provider):

```
export AWS_ACCESS_KEY_ID="<your_access_key>"
export AWS_SECRET_ACCESS_KEY="<your_secret_access_key>"
```

To define the region (depending on our needs), follow this guide:
https://help.ovhcloud.com/csm/en-gb-public-cloud-storage-s3-location?id=kb_article_view&sysparm_article=KB0047382

And then update the region variable in the `variables.tf` file.

Run the TF command `terraform apply`:
```bash
$ terraform apply
```

To destroy the bucket with all the objects inside, run the command `terraform destroy`.

For more information about object container storage you can read the [OVHcloud documentation](https://help.ovhcloud.com/csm/en-ie-documentation-storage-object-storage?id=kb_browse_cat&kb_id=38e74da5a884a950f07829d7d5c75217&kb_category=b29021c8e5a5edd0f078850a25104df8&spa=1).