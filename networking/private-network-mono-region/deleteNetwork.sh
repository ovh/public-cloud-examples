#!/bin/bash
  
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${DIR}

source ovhrc
source properties

# Remove Ext-Net network from state
terraform state rm openstack_networking_network_v2.Ext-Net

terraform destroy --auto-approve
