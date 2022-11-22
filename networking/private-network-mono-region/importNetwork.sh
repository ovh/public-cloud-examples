#!/bin/bash
  
DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${DIR}

source ovhrc
source properties

terraform init

# Import Router
rtrId="$(openstack router show ${TF_VAR_rtrName} -f json | jq -r '.id')" #
terraform import openstack_networking_router_v2.myRouter "${rtrId}"

# Import Interface
intId="$(openstack port list --router ${rtrId} | grep -w "${TF_VAR_rtrIp}" | awk '{print $2}')"
terraform import openstack_networking_router_interface_v2.myRouterInterface "${intId}"

# Import Subnet
terraform import openstack_networking_subnet_v2.mySubnet "$(openstack subnet list | grep "${TF_VAR_subnetName}" | awk '{print $2}')"

# Import Private Network
nid=$(utils/ovhAPI.sh GET /cloud/project/$TF_VAR_serviceName/network/private | jq --arg TF_VAR_pvNetworkName $TF_VAR_pvNetworkName -r '.[] | select(.name==$TF_VAR_pvNetworkName) | .id')
terraform import ovh_cloud_project_network_private.myPrivateNetwork "${TF_VAR_serviceName}/${nid}"

# Import Ext-Net Subnet
terraform import openstack_networking_network_v2.Ext-Net "$(openstack network list | grep -w "Ext-Net" | grep -v "Baremetal" | awk '{print $2}')"
