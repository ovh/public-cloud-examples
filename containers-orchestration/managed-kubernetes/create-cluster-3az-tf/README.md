## Create a MKS Premium cluster on 3AZ with Terraform

### General information
 - 🔗 [Using Terraform with OVHcloud](https://help.ovhcloud.com/csm/fr-terraform-at-ovhcloud?id=kb_article_view&sysparm_article=KB0054776)
 - 🔗 [Creating a cluster through Terraform](https://help.ovhcloud.com/csm/fr-public-cloud-kubernetes-create-cluster-with-terraform?id=kb_article_view&sysparm_article=KB0054966)
 - 🔗 [How to use Terraform](https://help.ovhcloud.com/csm/en-gb-public-cloud-compute-terraform?id=kb_article_view&sysparm_article=KB0050787)
 - 🔗 [ovh_cloud_project_kube](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_kube)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

### Set up
  - Install the [Terraform CLI](https://www.terraform.io/downloads.html)
  - Get the credentials from the OVHCloud Public Cloud project:
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)
  - Install the kubectl CLI

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
  - use the [kube.tf](my-ovh_kube_cluster.tf) file to define the resources to create and to display the kubeconfig file at the end of Terraform execution
  - run the `terraform init` command
  - run the `terraform plan` command
  - run the `terraform apply` command (~ 6-7 mins)

```bash
ovh_cloud_project_kube_nodepool.node_pool_multi_zones_a: Still creating... [6m0s elapsed]
ovh_cloud_project_kube_nodepool.node_pool_multi_zones_c: Still creating... [6m0s elapsed]
ovh_cloud_project_kube_nodepool.node_pool_multi_zones_a: Creation complete after 6m7s [id=019739fc-fc5f-720c-b449-0eb1c585f887]
ovh_cloud_project_kube_nodepool.node_pool_multi_zones_c: Creation complete after 6m7s [id=019739fc-fc72-760a-9fe6-e1264ea0395d]
ovh_cloud_project_kube_nodepool.node_pool_multi_zones_b: Creation complete after 6m7s [id=019739fc-fc5b-7296-aa55-8814e2068b4e]
```

  - get the `kubeconfig` value:

`terraform output -raw kubeconfig > mks_premium_3az.yml`

  - save the path of kubeconfig in an environment variable (for later ^^)

```bash
export KUBE_CLUSTER=$(pwd)/mks_premium_3az.yml
```

  - test the connexion to the Kubernetes:
  
`kubectl --kubeconfig=$KUBE_CLUSTER cluster-info`

  - list the node pool configuration:

`kubectl --kubeconfig=$KUBE_CLUSTER get np`

  - list the nodes:

`kubectl --kubeconfig=$KUBE_CLUSTER get no`

Note: you can run the `create.sh` script instead of executing each previous commands manually ;-)

### Destroy

  - destroy the cluster: `terraform destroy`

Note: you can run the `destroy.sh` script instead of executing the previous command manually ;-)


### After the demo

  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-
