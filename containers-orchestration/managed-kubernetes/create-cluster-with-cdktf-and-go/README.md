## Create a MKS cluster with Terraform

### General information
 - 🔗 [Using Terraform with OVHcloud](https://help.ovhcloud.com/csm/fr-terraform-at-ovhcloud?id=kb_article_view&sysparm_article=KB0054776)
 - 🔗 [Creating a cluster through CDK for Terraform](TODO)
 - 🔗 [ovh_cloud_project_kube](https://registry.terraform.io/providers/ovh/ovh/latest/docs/resources/cloud_project_kube)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

## Prerequisites

Export your credentials as environment variables.

| Provider Argument | Environment Variables    | Description                                                                                                           | Mandatory |
| ----------------- | ------------------------ | --------------------------------------------------------------------------------------------------------------------- | --------- |
| `endpoint`      | `OVH_ENDPOINT`         | OVHcloud Endpoint. Possible value are: `ovh-eu`, `ovh-ca`, `ovh-us`, `soyoustart-eu`, `soyoustart-ca`, `kimsufi-ca`, `kimsufi-eu`, `runabove-ca`                                       | ✅        |
| `application_key`      | `OVH_APPLICATION_KEY`         | OVHcloud Access Key                                       | ✅        |
| `application_secret`      | `OVH_APPLICATION_SECRET`         | OVHcloud Secret Key                               | ✅        |
| `consumer_key`      | `OVH_CONSUMER_KEY` | OVHcloud Consumer Key | ✅        |
| `service_name`      | `OVH_CLOUD_PROJECT_SERVICE` | OVHcloud Public Cloud project ID| ✅        |

 These keys can be generated via the [OVHcloud token generation page](https://api.ovh.com/createToken/?GET=/*&POST=/*&PUT=/*&DELETE=/*).

Example:

```bash
# OVHcloud provider needed keys
export OVH_ENDPOINT="ovh-eu"
export OVH_APPLICATION_KEY="xxx"
export OVH_APPLICATION_SECRET="xxx"
export OVH_CONSUMER_KEY="xxx"
export OVH_CLOUD_PROJECT_SERVICE="xxx"
```

### Set up
  - Install the [CDKTF CLI](https://developer.hashicorp.com/terraform/tutorials/cdktf/cdktf-install)
  - Install the kubectl CLI
  - Install Go

### Demo

  - run the `cdktf get` command (to download providers)
  - run the `cdktf deploy` command (~ 10 mins)
  - save the path of kubeconfig in an environment variable

```bash
export KUBE_CLUSTER=$(pwd)/kubeconfig.yaml
```

  - test the connexion to the Kubernetes:
  
`kubectl --kubeconfig=$KUBE_CLUSTER cluster-info`

  - list the node pool configuration:

`kubectl --kubeconfig=$KUBE_CLUSTER get np`

  - list the nodes:

`kubectl --kubeconfig=$KUBE_CLUSTER get no`

### Destroy

  - destroy the cluster: `cdktf destroy`

### After the demo

  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-