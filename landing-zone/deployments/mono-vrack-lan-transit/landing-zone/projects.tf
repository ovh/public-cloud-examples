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
#   Public Cloud Project: Hub
########################################################################################

resource "ovh_cloud_project" "hub" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  description    = "hubonevrack${local.name_suffix}"

  plan {
    duration     = data.ovh_order_cart_product_plan.cloud_project_order.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.cloud_project_order.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.cloud_project_order.selected_price.0.pricing_mode
    configuration {
      label = "vrack"
      value = ovh_vrack.shared.service_name
    }
  }
}
