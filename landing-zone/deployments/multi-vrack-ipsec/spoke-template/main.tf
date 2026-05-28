module "spoke" {
  source = "../../../modules/firewall/opnsense-ha"
  role   = "spoke-ipsec"

  depends_on = [time_sleep.wait_spoke_vrack]

  os_tenant_id            = ovh_cloud_project.spoke.project_id
  os_region               = var.compute_region
  az_primary              = local.az_primary
  az_secondary            = local.az_secondary
  ssh_public_key_path     = var.ssh_public_key_path
  os_instance_flavor_name = var.spoke_flavor

  admin_client_ip = var.admin_client_ip
  admin_password  = var.admin_password
  ha_password     = var.ha_password

  net_wan_vlan_id     = var.spoke_net_wan_vlan_id
  private_wan_cidr    = var.spoke_private_wan_cidr
  net_lan_vlan_id     = var.spoke_net_lan_vlan_id
  private_lan_cidr    = var.spoke_private_lan_cidr
  net_hasync_vlan_id  = var.spoke_net_hasync_vlan_id
  private_hasync_cidr = var.spoke_private_hasync_cidr

  template_extra_vars = {
    IPSEC_PSK_SECRET = var.ipsec_pre_shared_key
    IPSEC_REQID      = tostring(var.ipsec_reqid)
    HUB_FLOATING_IP  = var.hub_floating_ip
    HUB_PEER_ID      = var.hub_private_wan_cidr
    SPOKE_PEER_ID    = var.spoke_private_wan_cidr
    VTI_HUB_IP       = cidrhost(var.vti_link_cidr, 1)
    VTI_SPOKE_IP     = cidrhost(var.vti_link_cidr, 2)
  }
}
