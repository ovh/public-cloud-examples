module "spoke" {
  source     = "../../../modules/network/spoke-slot"
  depends_on = [time_sleep.wait_spoke_vrack, null_resource.openstack_ready]

  spoke_name = var.spoke_name
  slot       = var.slot
  networks   = var.networks

  openstack_cli_auth = {
    OS_AUTH_URL             = "https://auth.cloud.ovh.net/v3/"
    OS_IDENTITY_API_VERSION = "3"
    OS_USER_DOMAIN_NAME     = "Default"
    OS_PROJECT_DOMAIN_NAME  = "Default"
    OS_REGION_NAME          = var.compute_region
    OS_USERNAME             = ovh_cloud_project_user.spoke_iac.username
    OS_PASSWORD             = ovh_cloud_project_user.spoke_iac.password
    OS_PROJECT_ID           = ovh_cloud_project.spoke.project_id
    OS_TENANT_ID            = ovh_cloud_project.spoke.project_id
  }

  hub_lan_vlan_id = var.hub_lan_vlan_id
  hub_lan_cidr    = var.hub_lan_cidr
  hub_lan_carp_ip = var.hub_lan_carp_ip

  extra_egress = var.extra_egress
}
