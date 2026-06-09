module "spoke" {
  source = "../../../modules/network/spoke-one-vrack"

  depends_on = [time_sleep.wait_spoke_vrack]

  os_tenant_id = ovh_cloud_project.spoke.project_id
  os_region    = var.compute_region

  spoke_name = var.spoke_name

  hub_lan_vlan_id   = var.hub_lan_vlan_id
  hub_lan_cidr      = var.hub_lan_cidr
  hub_lan_carp_ip   = var.hub_lan_carp_ip
  transit_router_ip = var.transit_router_ip

  networks = var.networks
}
