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
#   Public Cloud Project: Spoke — attached to the hub vRack at order time
########################################################################################
resource "ovh_cloud_project" "spoke" {
  ovh_subsidiary = data.ovh_order_cart.mycart.ovh_subsidiary
  description    = "${var.spoke_name}-${local.name_suffix}"
  plan {
    duration     = data.ovh_order_cart_product_plan.cloud_project_order.selected_price.0.duration
    plan_code    = data.ovh_order_cart_product_plan.cloud_project_order.plan_code
    pricing_mode = data.ovh_order_cart_product_plan.cloud_project_order.selected_price.0.pricing_mode
    configuration {
      label = "vrack"
      value = var.hub_vrack_service_name
    }
  }
}

# A fresh project ships with every region enabled; wait for its Keystone catalog to serve the
# region consistently before the first OpenStack call.
resource "null_resource" "openstack_ready" {
  depends_on = [ovh_cloud_project_user.spoke_iac]
  provisioner "local-exec" {
    command = "${path.module}/../../../tools/wait-openstack-catalog.sh ${var.compute_region}"
    environment = {
      OS_USERNAME  = ovh_cloud_project_user.spoke_iac.username
      OS_PASSWORD  = ovh_cloud_project_user.spoke_iac.password
      OS_TENANT_ID = ovh_cloud_project.spoke.project_id
    }
  }
}
