########################################################################################
# OPNsense HA cluster
########################################################################################

module "opnsense_ha" {
  source = "../../modules/firewall/opnsense-ha"

  role = "hub-simple"

  os_region               = var.region
  az_primary              = local.az_primary
  az_secondary            = local.az_secondary
  os_instance_flavor_name = var.flavor
  ssh_public_key_path     = var.ssh_public_key_path
  opnsense_version        = var.opnsense_version

  admin_client_ip = var.admin_client_ip
  admin_password  = var.admin_password
  ha_password     = var.ha_password
  api_key         = random_string.api_key.result
  api_secret_hash = random_password.api_secret.bcrypt_hash

  net_wan_vlan_id     = var.vlan_wan
  private_wan_cidr    = var.cidr_wan
  net_lan_vlan_id     = var.vlan_lan
  private_lan_cidr    = var.cidr_lan
  net_hasync_vlan_id  = var.vlan_hasync
  private_hasync_cidr = var.cidr_hasync
}
