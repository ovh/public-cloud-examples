## Create a Managed Private Registry with Pulumi (and existing OVHcloud TF provider) in Go/Golang

This project uses the existing OVHcloud Terraform provider and allows you to deploy with Pulumi in Go.

### Project creation

```bash
$ pulumi new go -y

$ pulumi package add terraform-provider ovh/ovh

$ go mod edit -replace github.com/pulumi/pulumi-terraform-provider/sdks/go/ovh=./sdks/ovh

# edit main.go with your code

$ go mod tidy

$ pulumi up

## Project execution

$ pulumi login --local

$ pulumi up
```

TODO: xxx



### Set up
  - Install the [Pulumi CLI](https://www.pulumi.com/docs/install/)
  - An account in [Pulumi](https://www.pulumi.com/)
  - A [Pulumi access token](https://app.pulumi.com/account/tokens)
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

  - set the serviceName in Pulumi stack configuration

`pulumi config set serviceName $(echo $OVH_CLOUD_PROJECT_SERVICE)`

  - use the [main.go](main.go) file to define the resources to create

  - create a registry with a user and a project (~ 7-8 mins)
`pulumi up`

  - display the registry URL, login and password and save them in environment variables (you will use)

```bash
export PRIVATE_REGISTRY_URL=$(pulumi stack output registryURL -s dev)
export PRIVATE_REGISTRY_USER=$(pulumi stack output registryUser -s dev)
export PRIVATE_REGISTRY_PASSWORD=$(pulumi stack output registryPassword --show-secrets -s dev)
export PRIVATE_REGISTRY_PROJECT=$(pulumi stack output project -s dev)

echo $PRIVATE_REGISTRY_URL
echo $PRIVATE_REGISTRY_USER
echo $PRIVATE_REGISTRY_PASSWORD
echo $PRIVATE_REGISTRY_PROJECT
```

Note: you can run the `create.sh` script instead of executing each previous commands manually ;-)

### Destroy

  - destroy all the resources (registry, user, project): `pulumi destroy`

Note: you can run the `destroy.sh` script instead of executing the previous command manually ;-)


### After the demo

  - if needed delete the token with https://api.ovh.com/console-preview/?section=%2Fme&branch=v1#delete-/me/api/credential/-credentialId-