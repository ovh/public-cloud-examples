data "ovh_order_cart_product_plan" "vrack_order" {
  cart_id        = data.ovh_order_cart.mycart.id
  price_capacity = "renew"
  product        = "vrack"
  plan_code      = "vrack"
}

resource "ovh_vrack" "spoke_vrack" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  name           = "${var.spoke_vrack_name}-${local.name_suffix}"
  description    = "${var.spoke_vrack_description} (${var.spoke_vrack_name}-${local.name_suffix})"

  plan {
    duration     = data.ovh_order_cart_product_plan.vrack_order.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.vrack_order.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.vrack_order.selected_price.0.pricing_mode
  }
}

resource "time_sleep" "wait_spoke_vrack" {
  depends_on      = [ovh_cloud_project.spoke]
  create_duration = "30s"
}

