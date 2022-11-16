#!/bin/bash
  
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${DIR}

source ovhrc
source properties

terraform init

# Import Ext-Net subnet
terraform import openstack_networking_network_v2.Ext-Net "$(openstack network list | grep -w "Ext-Net" | grep -v "Baremetal" | awk '{print $2}')"

terraform plan
terraform apply --auto-approve
