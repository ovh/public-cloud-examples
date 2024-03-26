## Create a MKS cluster through Rancher

### General information
 - 🔗 [Getting started with Managed Rancher Service](https://help.ovhcloud.com/csm/en-gb-public-cloud-managed-rancher-service-getting-started?id=kb_article_view&sysparm_article=KB0061909)
 - 🔗 [OVH token generation page](https://www.ovh.com/auth/api/createToken?GET=/*&POST=/*&PUT=/*&DELETE=/*)

### Set up
  - Get the credentials from the OVHCloud Public Cloud project:
    - `application_key`
    - `application_secret`
    - `consumer_key`
  - Get the `service_name` (Public Cloud project ID)
  - Install the kubectl CLI

### Demo

#### Deploy a Managed Rancher

  - log in to the OVHcloud Control Panel and open the **Public Cloud** section. Then access the **Managed Rancher Service** under the **Containers & Orchestration** section.

  - click on the **Create a Managed Rancher Service** button
  - fill a name (`my_demo_rancher` for example), choose the **Standard** plan, the recommended version then click on the **Create a Managed Rancher Service** button.
  Rancher instances are pre-provisioned, so your instance will be created immediately.

  - In the list of existing Managed Rancher Service, click on your instance, then click on **Generate access code** button to generate the login and password to access to Rancher. Save the login and password and click on **Go to Rancher** button.

  -  Copy/paste the password in **password** field and click on **Log in with Local User** button.

  - A new password wil be generated, save it! Save the server URL too, check the **End User License Agreement** checkbox and click on the **Continue** button.

#### Create a MKS

  - Follow the [Create a Kubernetes cluster with Terraform](../managed-kubernetes/create-cluster-with-tf) guide

#### Import an existing MKS through Rancher

  - In Rancher UI, click on the **Import Existing** button and then on the **Generic** driver.
  - fill the name of your cluster and then click on the **Create** button (**if the name contains `_` replace by `-`!**)
  - Run the instructions provided on the **Registration** tab
