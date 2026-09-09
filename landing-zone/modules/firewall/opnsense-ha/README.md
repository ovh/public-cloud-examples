# Module `firewall/opnsense-ha`

Deploys an OPNsense active/passive pair (CARP + pfsync + xmlrpc) on an OVHcloud Public Cloud project, with plain OpenStack credentials.

## What it creates

| Resource | Notes |
|----------|-------|
| 3 vRack networks + subnets (WAN, LAN, HASYNC) | VLAN IDs and CIDRs from variables; the LAN subnet's `gateway_ip` is the LAN CARP VIP (`.99`) so DHCP clients get the right default route |
| 2 ports per network + 2 detached CARP VIP ports (`.99`) | port security disabled everywhere (CARP MAC/IP) |
| Neutron router on `Ext-Net` + interface on the WAN subnet | this is an OVHcloud *Gateway* (size S); takes the subnet `.1` |
| Floating IP bound to the WAN VIP port | follows the CARP master |
| Glance image `OPNsense <opnsense_version> Cloud-Ready` | imported from the URL in `image_source_url` (defaults to the public OVHcloud bucket) |
| 2 instances in an anti-affinity server group | config injected through `user_data` (config-drive), see `docs/04` |

No OVH API provider is required since 26.7: the former `ovh_cloud_project_gateway` and `ovh_cloud_project_ssh_key` resources were replaced by their OpenStack equivalents. `os_tenant_id` is kept as a no-op for existing callers.

## Templates

`templates/<role>/config-{active,passive}.xml` are OpenTofu templates rendered into a full `config.xml`.

`hub-simple` is written for the **OPNsense 26.7 configuration model**:

| Section | Location in config.xml |
|---------|------------------------|
| Firewall rules | `OPNsense/Firewall/Filter/rules` (model version 1.0.6) |
| Source NAT rules | `OPNsense/Firewall/Filter/snatrules`; the mode stays in `nat/outbound/mode` (that is where 26.7 stores it). Hybrid mode only auto-NATs interface networks, so slot supernets (behind static routes) get their own rule when `slot_count > 0` |
| Aliases (`AdminClients`) | `OPNsense/Firewall/Alias` |
| Gateway `WANGW` | `OPNsense/Gateways` |
| HA (pfsync, xmlrpc, `syncitems`) | root `hasync` node — the only place OPNsense reads it from |
| CARP VIPs, tunables | `virtualip`, `sysctl` |

The HA sync interface is assigned as `opt1` (a key named `hasync` would collide with the `//hasync` model mount point). Object UUIDs are derived with `uuidv5()` so both nodes start with identical ids.

`hub-ipsec` and `spoke-ipsec` are **deprecated**: legacy `filter`/`nat` sections and the pre-26.7 HA layout (CARP only, no pfsync, no config sync). Kept for reference only.

## Hub mode (mono-vRack landing zone)

Two module inputs turn the standalone firewall into the landing-zone hub, both off by default:

| Input | Effect |
|---|---|
| `slot_count = N` | one OPNsense gateway + static route per spoke slot *k* (`cidrsubnet(slot_supernet_base, 8, k)` via `cidrhost(private_lan_cidr, slot_transit_offset + k)`) pre-provisioned in the XML, plus one Source NAT rule `slot_supernet_base → WAN CARP VIP` (without it, a spoke flow allowed by the firewall leaves the WAN untranslated and silently times out) — no OVH resource, no Day-2 call. Hub WAN/LAN/HASYNC must stay outside `slot_supernet_base`, `172.17.0.0/16` and `172.31.0.0/17` (preconditions enforce it — the last two are reserved by OVHcloud for Docker on MKS nodes and for Ext-Net Floating IP gateway ports). |
| `hub_services = true` | unbound DNS, ntpd and an explicit squid proxy (:3128) on the LAN CARP VIP, `os-squid` listed in `system/firmware/plugins`, anti-lockout off, and the zero-trust LAN policy: spokes reach the VIP services and each other over ICMP (logged), everything else is denied and logged; `LAN to any` is removed. |
| `proxy_connect_ports = [443, 6514, 12202]` | ports the proxy tunnels with CONNECT (squid `SSL_ports`); 443 by default, add 6514/12202 for log shippers talking TLS to Logs Data Platform |
| `proxy_allowed_domains = ["ubuntu.com", "docker.io"]` | with `hub_services`: the proxy only serves these destination domains (and their sub-domains) — squid whitelist over a deny-all blacklist; HTTPS (CONNECT) is limited to port 443. Empty (default) = any destination. Every request is logged in both cases. |

Plugins listed in the config are **not** installed at boot: run `tools/hub-postboot.sh` once after the first apply (idempotent): it waits for the API, calls `core/firmware/syncPlugins`, normalises the pre-seeded proxy model (`proxy/settings/set {}`) and starts the proxy on both nodes.

## Upgrading an existing deployment to this module version

Applying this version on a cluster created with the previous one will:

- replace the gateway (`ovh_cloud_project_gateway` → `openstack_networking_router_v2`), which interrupts WAN connectivity while it is recreated;
- replace the Glance image (26.1 → 26.7 URL) and therefore **rebuild both instances** — pin `opnsense_version = "26.1"` in the module call to keep the current image until you plan the upgrade;
- delete the cosmetic `ovh_cloud_project_ssh_key` registration.

- update the LAN subnet `gateway_ip` to the CARP VIP (in-place Neutron update; DHCP clients pick it up on their next lease renewal).

Run `tofu plan` and read it before applying on a production cluster.

## Validated on 2026-08-27 (GRA9, OPNsense 26.7)

Both nodes boot on the injected config (API answers with the generated key), CARP MASTER/BACKUP on WAN and LAN with unicast peers, `pfsync0` `syncok: 1` on both nodes with states visible on the secondary, gateway monitoring *Online*, rules and Source NAT listed as native MVC objects (0 legacy), XML-RPC sync to the secondary successful (`Filter sync successfully completed`), LAN client egress through the Floating IP via the WAN CARP VIP.
