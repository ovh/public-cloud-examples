#!/bin/bash

SCRIPTROOTDIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPTROOTDIR

source ./ovhrc
source ./properties

terraform init

for srv in $(openstack server list -f csv | grep -E "k3s[0-9]{3}" | cut -d ',' -f1,2)
do

	srvName=$(echo $srv | cut -d ',' -f1 | tr -d '"')
	srvId=$(echo $srv | cut -d ',' -f2 | tr -d '"')
	terraform import openstack_compute_instance_v2.inst_[\"$srvName\"] $srvId

done
