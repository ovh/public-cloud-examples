#!/bin/bash

SCRIPTROOTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPTROOTDIR

source ./ovhrc
source ./properties

image_id="$(openstack image list -f csv | grep "\"$image_name\"" | cut -d ',' -f1 | tr -d '"')"
flavor_id="$(openstack flavor list -f csv | grep "\"$flavor_name\"" | cut -d ',' -f1 | tr -d '"')"

# RAZ variables.tf
rm -f variables.tf

cat <<EOF > variables.tf
variable "keypair_admin" {
 description = "Keypair Name"
 type = string
}

variable "image_id" {
 description = "Image Id"
 type = string
 default = "$image_id"
}

variable "flavor_id" {
 description = "Flavor Id"
 type = string
 default = "$flavor_id"
}

variable "name_list" {
 description = "Servers List"
 type = list
 description = "List of instances"
 default = [
EOF

i=1
while [ $i -le $nb_instances ]
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
