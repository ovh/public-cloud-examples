########################################################################################
#   OVH Order Cart
########################################################################################
data "ovh_me" "myaccount" {}

data "ovh_order_cart" "mycart" {
  ovh_subsidiary = data.ovh_me.myaccount.ovh_subsidiary
}

data "ovh_order_cart_product_plan" "cloud_project_order" {
  cart_id        = data.ovh_order_cart.mycart.id
  price_capacity = "renew"
  product        = "cloud"
  plan_code      = var.ovh_endpoint == "ovh-us" ? "project" : "project.2018"
}

########################################################################################
#   Public Cloud Project: Hub — OVHcloud delivers its vRack automatically (a few minutes later)
########################################################################################
resource "ovh_cloud_project" "hub" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  description    = "hub${local.name_suffix}"
  plan {
    duration     = data.ovh_order_cart_product_plan.cloud_project_order.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.cloud_project_order.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.cloud_project_order.selected_price.0.pricing_mode
  }
}

########################################################################################
#   A fresh project ships with every region already enabled, but its Keystone catalog
#   converges asynchronously (the auth VIP fronts several backends): wait until the
#   region's compute/image/network endpoints answer consistently before the first
#   OpenStack call of the hub module.
########################################################################################
resource "null_resource" "openstack_ready" {
  depends_on = [ovh_cloud_project_user.hub_user]
  provisioner "local-exec" {
    command = "${path.module}/../../../tools/wait-openstack-catalog.sh ${var.compute_region}"
    environment = {
      OS_USERNAME  = ovh_cloud_project_user.hub_user.username
      OS_PASSWORD  = ovh_cloud_project_user.hub_user.password
      OS_TENANT_ID = ovh_cloud_project.hub.project_id
    }
  }
}
