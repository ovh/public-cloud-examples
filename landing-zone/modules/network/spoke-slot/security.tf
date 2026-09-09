########################################################################################
#   Zero-trust security groups. Neutron creates every new group with two implicit
#   egress-any rules: delete_default_rules removes them so only what is listed here exists.
########################################################################################

# base: what any workload needs — metadata, and the hub services on the LAN VIP
resource "openstack_networking_secgroup_v2" "base" {
  name                 = "${var.spoke_name}-base"
  description          = "Zero-trust base: metadata + hub services (DNS/NTP/proxy) on ${var.hub_lan_carp_ip}, no public egress"
  delete_default_rules = true
}

locals {
  base_rules = merge(
    {
      metadata = { protocol = "tcp", port = 80, cidr = "169.254.169.254/32" }
      dns_udp  = { protocol = "udp", port = 53, cidr = "${var.hub_lan_carp_ip}/32" }
      dns_tcp  = { protocol = "tcp", port = 53, cidr = "${var.hub_lan_carp_ip}/32" }
      ntp      = { protocol = "udp", port = 123, cidr = "${var.hub_lan_carp_ip}/32" }
      proxy    = { protocol = "tcp", port = var.proxy_port, cidr = "${var.hub_lan_carp_ip}/32" }
    },
    { for i, r in var.extra_egress : "extra_${i}" => { protocol = r.protocol, port = r.port, cidr = r.cidr } }
  )
}

resource "openstack_networking_secgroup_rule_v2" "base_egress" {
  for_each          = local.base_rules
  security_group_id = openstack_networking_secgroup_v2.base.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  port_range_min    = each.value.port
  port_range_max    = each.value.port
  remote_ip_prefix  = each.value.cidr
  description       = each.key
}

resource "openstack_networking_secgroup_rule_v2" "base_icmp_hub" {
  security_group_id = openstack_networking_secgroup_v2.base.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "${var.hub_lan_carp_ip}/32"
  description       = "ping the hub VIP"
}

# intra: members of the bubble may talk to each other (ingress + egress restricted to the group)
resource "openstack_networking_secgroup_v2" "intra" {
  name                 = "${var.spoke_name}-intra"
  description          = "Instances of ${var.spoke_name} may talk to each other"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "intra" {
  for_each          = toset(["ingress", "egress"])
  security_group_id = openstack_networking_secgroup_v2.intra.id
  direction         = each.key
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.intra.id
}

# default: strip the project's implicit allow-all group so an instance booted without an
# explicit SG has no connectivity (Neutron does not allow deleting the group itself)
resource "null_resource" "strip_default_secgroup" {
  count    = var.strip_default_secgroup ? 1 : 0
  triggers = { project = openstack_networking_router_v2.spoke.tenant_id }

  lifecycle {
    precondition {
      condition     = !var.strip_default_secgroup || length(var.openstack_cli_auth) > 0
      error_message = "strip_default_secgroup needs openstack_cli_auth (the spoke project's own credentials): the CLI must never inherit the operator's ambient OpenStack environment."
    }
  }

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    environment = var.openstack_cli_auth
    command     = <<-EOT
      # Never trust the inherited environment: refuse to act unless the token is scoped to this spoke's project.
      unset OS_CLOUD OS_CLIENT_CONFIG_FILE
      TOKEN_PROJECT=$(openstack token issue -f value -c project_id 2>/dev/null)
      if [ "$TOKEN_PROJECT" != "${openstack_networking_router_v2.spoke.tenant_id}" ]; then
        echo "refusing to touch the default security group: credentials are scoped to '$TOKEN_PROJECT', expected '${openstack_networking_router_v2.spoke.tenant_id}'" >&2
        exit 1
      fi
      # A freshly created project may re-stamp its default rules while we delete them, and a
      # delete can transiently return 403: several passes, success = zero rule left.
      for pass in 1 2 3 4; do
        for id in $(openstack security group rule list default -f value -c ID); do
          openstack security group rule delete "$id" || true
        done
        n=$(openstack security group rule list default -f value -c ID | wc -l)
        [ "$n" -eq 0 ] && { echo "default security group of project ${openstack_networking_router_v2.spoke.tenant_id}: 0 rule(s) left (pass $pass)"; exit 0; }
        sleep 15
      done
      echo "default security group of project ${openstack_networking_router_v2.spoke.tenant_id} still has $n rule(s)" >&2
      exit 1
    EOT
  }
}
