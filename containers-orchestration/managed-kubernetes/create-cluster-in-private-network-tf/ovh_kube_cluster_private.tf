# Deploy a Kubernetes cluster that have all the needed requirements for new Public Cloud Load Balancer

# 0. Create a vRack (comment this part if you have an existing one)

# data "ovh_me" "myaccount" {}

# data "ovh_order_cart" "mycart" {
#   ovh_subsidiary = data.ovh_me.myaccount.ovh_subsidiary
# }

# data "ovh_order_cart_product_plan" "vrack" {
#  cart_id        = data.ovh_order_cart.mycart.id
#  price_capacity = "renew"
#  product        = "vrack"
#  plan_code      = "vrack"
# }

# resource "ovh_vrack" "vrack" {
#  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
#  name          = "my-vrack"
#  description   = "my vrack"

#  plan {
#    duration     = data.ovh_order_cart_product_plan.vrack.selected_price.0.duration
#    plan_code    = data.ovh_order_cart_product_plan.vrack.plan_code
#    pricing_mode = data.ovh_order_cart_product_plan.vrack.selected_price.0.pricing_mode
#  }
# }

# 1. Attach your vRack to your Public Cloud project (comment this part if your vRack is already attached to your Public Cloud project)

# resource "ovh_vrack_cloudproject" "attach" {
#   service_name = ovh_vrack.vrack.id
# 	project_id   = var.service_name
# }

# 2. Create a private network
resource "ovh_cloud_project_network_private" "network" {
  service_name = var.service_name
  vlan_id    = 666 # the VLAN ID is unique
  name       = "mks_gra11_private_network"
  regions    = ["GRA11"]
}

# And a subnet
resource "ovh_cloud_project_network_private_subnet" "networksubnet" {
  service_name = ovh_cloud_project_network_private.network.service_name
  network_id   = ovh_cloud_project_network_private.network.id

  # whatever region, for test purpose
  region     = "GRA11"
  start      = "192.168.168.100"
  end        = "192.168.168.200"
  network    = "192.168.168.0/24"
  dhcp       = true
  no_gateway = false

  depends_on   = [ovh_cloud_project_network_private.network]
}

output "openstackID" {
  value = one(ovh_cloud_project_network_private.network.regions_attributes[*].openstackid)
}

# 3. Create a MKS in the private network attached to a vRack

resource "ovh_cloud_project_kube" "mycluster" {
  service_name  = var.service_name
  name          = "my-kube-gra"
  region        = "GRA11"

  private_network_id = tolist(ovh_cloud_project_network_private.network.regions_attributes[*].openstackid)[0]

  private_network_configuration {
      default_vrack_gateway              = ""
      private_network_routing_as_default = false
  }

  depends_on = [ovh_cloud_project_network_private_subnet.networksubnet]
}

output "kubeconfig" {
  value = ovh_cloud_project_kube.mycluster.kubeconfig
  sensitive = true
}

# 4. Create a node pool for the MKS cluster
resource "ovh_cloud_project_kube_nodepool" "node_pool" {
  service_name  = var.service_name
  kube_id       = ovh_cloud_project_kube.mycluster.id
  name          = "my-pool-1" //Warning: "_" char is not allowed!
  flavor_name   = "b3-8" // Warning: B3 compute instances are not available in all the regions
  desired_nodes = 1
  max_nodes     = 1
  min_nodes     = 1
}