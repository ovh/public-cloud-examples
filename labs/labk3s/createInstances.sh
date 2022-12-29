#!/bin/bash

SCRIPTROOTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPTROOTDIR

source ./ovhrc
source ./properties

imageId="$(openstack image list -f json | jq -r --arg imageName "$imageName" '.[] | select(.Name==$imageName) | .ID')"
flavorId="$(openstack flavor list -f json | jq -r --arg flavorName "$flavorName" '.[] | select(.Name==$flavorName) | .ID')"

# RAZ variables.tf
rm -f variables.tf

cat <<EOF > variables.tf
variable "keypairAdmin" {
 type = string
}

variable "imageId" {
 type = string
 default = "$imageId"
}

variable "flavorId" {
 type = string
 default = "$flavorId"
}

variable "nameList" {
 type = list
 description = "List of instances"
 default = [
EOF

i=1
while [ $i -le $nbInstances ]
do
  echo \"k3s$(printf "%03d" $i)\", >> variables.tf
  ((i++))
done

cat <<EOF >> variables.tf
 ]
}
EOF

# Create Instance
terraform init
terraform plan
terraform apply --auto-approve
