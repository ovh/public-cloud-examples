#!/bin/bash

# Stop on error and display executed commands
set -eo xtrace

terraform init

terraform apply -auto-approve

export RANCHER_URL=$(terraform output rancher_url)
export RANCHER_PASSWORD=$(terraform output rancher_password)

echo $RANCHER_URL
echo $RANCHER_PASSWORD