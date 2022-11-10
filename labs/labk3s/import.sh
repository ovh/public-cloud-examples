#!/bin/bash

DIR="/workspace/OVHcloud-small-recipes"
cd ${DIR}/labk3s

terraform init

for srv in $(openstack server list -f json | jq -r '.[] | select(.Name? | match("k3s[0-9][0-9]")) | .Name + ";" + .ID ')
do

	srvName=$(echo $srv | cut -d ";" -f1)
	srvId=$(echo $srv | cut -d ";" -f2)
	terraform import openstack_compute_instance_v2.inst_[\"$srvName\"] $srvId

done
