module "hub" {
  source = "../../../modules/firewall/opnsense-ha"

  role       = "hub-simple"
  depends_on = [data.ovh_cloud_project_vrack.hub, null_resource.openstack_ready]
  providers = {
    openstack = openstack.hub
  }

  os_region               = var.compute_region
  az_primary              = local.az_primary
  az_secondary            = local.az_secondary
  ssh_public_key_path     = var.ssh_public_key_path
  os_instance_flavor_name = var.hub_flavor
  opnsense_version        = var.opnsense_version

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

  slot_count            = var.slot_count
  hub_services          = var.hub_services
  proxy_allowed_domains = var.proxy_allowed_domains
  proxy_connect_ports   = var.proxy_connect_ports
}

########################################################################################
#   Day-1 post-boot (hub services only): install the plugins listed in config (os-squid)
#   and start the proxy on both nodes. Idempotent — tools/hub-postboot.sh.
########################################################################################
resource "local_sensitive_file" "hub_ssh_key" {
  count           = var.ssh_public_key_path == null ? 1 : 0
  filename        = "${path.module}/.ssh/hub_key"
  content         = module.hub.ssh_private_key
  file_permission = "0600"
}

locals {
  hub_ssh_key = var.ssh_public_key_path != null ? trimsuffix(var.ssh_public_key_path, ".pub") : "${path.module}/.ssh/hub_key"
}

resource "null_resource" "hub_postboot" {
  count      = var.hub_services ? 1 : 0
  depends_on = [module.hub, local_sensitive_file.hub_ssh_key]
  triggers = {
    fip       = module.hub.floating_ip
    script    = filesha256("${path.module}/../../../tools/hub-postboot.sh")
    whitelist = module.hub.proxy_whitelist # a change of proxy_allowed_domains re-runs the script: no instance rebuild
    sslports  = module.hub.proxy_ssl_ports
    syslog    = var.hub_remote_syslog == null ? "" : "${var.hub_remote_syslog.host}:${var.hub_remote_syslog.port}"
  }
  provisioner "local-exec" {
    command = "${path.module}/../../../tools/hub-postboot.sh ${module.hub.floating_ip} ${cidrhost(var.hub_private_hasync_cidr, 2)} ${local.hub_ssh_key}"
    environment = {
      API_AUTH        = "${random_string.hub_api_key.result}:${random_password.hub_api_secret.result}"
      PROXY_WHITELIST = module.hub.proxy_whitelist
      PROXY_SSL_PORTS = module.hub.proxy_ssl_ports
      REMOTE_SYSLOG   = var.hub_remote_syslog == null ? "" : "${var.hub_remote_syslog.host}:${var.hub_remote_syslog.port}"
    }
  }
}
