#!/bin/bash

SCRIPTROOTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPTROOTDIR

source ./ovhrc
source ./properties

terraform init

for srv in $(openstack server list -f json | jq -r '.[] | select(.Name? | match("k3s[0-9][0-9]")) | .Name + ";" + .ID ')
do

	srvName=$(echo $srv | cut -d ";" -f1)
	srvId=$(echo $srv | cut -d ";" -f2)
	terraform import openstack_compute_instance_v2.inst_[\"$srvName\"] $srvId

done
