resource "ovh_cloud_project_network_private" "myPrivateNetwork" {
   service_name 	= var.serviceName
   name       		= var.pvNetworkName
   vlan_id    		= var.pvNetworkId
   regions    		= [var.region]
}

resource "openstack_networking_subnet_v2" "mySubnet" {
   network_id 		= tolist(ovh_cloud_project_network_private.myPrivateNetwork.regions_attributes)[0].openstackid
   name       		= var.subnetName
   region     		= var.region
   cidr       		= var.subnetCIDR
   enable_dhcp 		= true
   no_gateway 		= false
   dns_nameservers 	= ["1.1.1.1","1.0.0.1"]

   allocation_pool {
     start      	= var.subnetDHCPStart
     end        	= var.subnetDHCPEnd
   }
}

resource "openstack_networking_network_v2" "Ext-Net" {
  name        		= "Ext-Net"
}

resource "openstack_networking_router_v2" "myRouter" {
  name                	= var.rtrName
  admin_state_up      	= true
  external_network_id 	= "${openstack_networking_network_v2.Ext-Net.id}"
}

resource "openstack_networking_router_interface_v2" "myRouterInterface" {
  router_id 		= "${openstack_networking_router_v2.myRouter.id}"
  subnet_id 		= "${openstack_networking_subnet_v2.mySubnet.id}"
}
