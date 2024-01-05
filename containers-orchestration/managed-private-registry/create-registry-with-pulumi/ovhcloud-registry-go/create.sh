#!/bin/bash

set -eo xtrace

pulumi config -s dev set serviceName $(echo $OVH_CLOUD_PROJECT_SERVICE)

pulumi up -s dev --yes

export PRIVATE_REGISTRY_URL=$(pulumi stack output registryURL -s dev)
export PRIVATE_REGISTRY_USER=$(pulumi stack output registryUser -s dev)
export PRIVATE_REGISTRY_PASSWORD=$(pulumi stack output registryPassword --show-secrets -s dev)
export PRIVATE_REGISTRY_PROJECT=$(pulumi stack output project -s dev)
export PRIVATE_REGISTRY_URL_WITHOUT_SCHEME=${PRIVATE_REGISTRY_URL#*//}

echo $PRIVATE_REGISTRY_URL
echo $PRIVATE_REGISTRY_URL_WITHOUT_SCHEME
echo $PRIVATE_REGISTRY_USER
echo $PRIVATE_REGISTRY_PASSWORD
echo $PRIVATE_REGISTRY_PROJECT