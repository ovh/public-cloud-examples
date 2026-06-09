module "hub" {
  source = "../../../modules/firewall/opnsense-ha"
  role   = "hub-ipsec"

  depends_on = [time_sleep.wait_hub_vrack]

  providers = {
    openstack = openstack.hub
  }

  os_tenant_id            = ovh_cloud_project.hub.project_id
  os_region               = var.compute_region
  az_primary              = local.az_primary
  az_secondary            = local.az_secondary
  ssh_public_key_path     = var.ssh_public_key_path
  os_instance_flavor_name = var.hub_flavor

  admin_client_ip = var.admin_client_ip
  admin_password  = var.admin_password
  ha_password     = var.ha_password

  api_key         = random_string.hub_api_key.result
  api_secret_hash = random_password.hub_api_secret.bcrypt_hash

  net_wan_vlan_id     = var.hub_net_wan_vlan_id
  private_wan_cidr    = var.hub_private_wan_cidr
  net_lan_vlan_id     = var.hub_net_lan_vlan_id
  private_lan_cidr    = var.hub_private_lan_cidr
  net_hasync_vlan_id  = var.hub_net_hasync_vlan_id
  private_hasync_cidr = var.hub_private_hasync_cidr

  template_extra_vars = {
    IPSEC_PSK_SECRET  = var.ipsec_pre_shared_key
    SPOKE_FLOATING_IP = module.spoke_qa.floating_ip
    HUB_PEER_ID       = var.hub_private_wan_cidr
    SPOKE_PEER_ID     = var.spoke_qa_private_wan_cidr
    VTI_HUB_IP        = cidrhost(var.vti_link_cidr, 1)
    VTI_SPOKE_IP      = cidrhost(var.vti_link_cidr, 2)
    SPOKE_LAN_CIDR    = module.spoke_qa.lan_cidr
  }
}
