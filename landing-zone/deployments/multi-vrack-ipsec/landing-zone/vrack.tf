########################################################################################
#   vRack order plans
########################################################################################

data "ovh_order_cart_product_plan" "vrack_order" {
  cart_id        = data.ovh_order_cart.mycart.id
  price_capacity = "renew"
  product        = "vrack"
  plan_code      = "vrack"
}

########################################################################################
#   vRack: Hub
########################################################################################

resource "ovh_vrack" "hub_vrack" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  name           = "hub${local.name_suffix}"
  description    = "Hub Infrastructure vRack (hub${local.name_suffix})"

  plan {
    duration     = data.ovh_order_cart_product_plan.vrack_order.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.vrack_order.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.vrack_order.selected_price.0.pricing_mode
  }
}

resource "time_sleep" "wait_hub_vrack" {
  depends_on      = [ovh_cloud_project.hub]
  create_duration = "30s"
}

########################################################################################
#   vRack: Spoke QA
########################################################################################

resource "ovh_vrack" "spoke_qa_vrack" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  name           = "spokeqa${local.name_suffix}"
  description    = "Spoke QA vRack (spokeqa${local.name_suffix})"

  plan {
    duration     = data.ovh_order_cart_product_plan.vrack_order.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.vrack_order.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.vrack_order.selected_price.0.pricing_mode
  }
}

resource "time_sleep" "wait_spoke_qa_vrack" {
  depends_on      = [ovh_cloud_project.spoke_qa]
  create_duration = "30s"
}

