# Module `network/spoke-slot`

Firewall-less spoke of the mono-vRack landing zone, driven by a single **slot number**.
Everything else is derived (supernet, LAN CIDRs, VLAN IDs, transit IP), and the hub already
carries the matching gateway + static route for every slot, so a spoke never calls the hub.

| Input | Derived value (slot k) |
|---|---|
| `slot = k` | supernet `cidrsubnet(slot_supernet_base, 8, k)` → `10.k.0.0/16` |
| `networks = { app = 0, db = 1 }` | LAN `10.k.0.0/24` VLAN `1000+10k`, LAN `10.k.1.0/24` VLAN `1001+10k` |
| transit | port `cidrhost(hub_lan_cidr, 10+k)` on the hub LAN VLAN, default route → hub CARP VIP |
| slots **2 and 3** | reserved (`10.2.0.0/16`, `10.3.0.0/16` = default MKS pod/service CIDRs) — refused unless `allow_kube_default_cidr_overlap = true` |

Security model (zero-trust, admin-curated): `<spoke>-base` allows only metadata and the hub services
(DNS/NTP/proxy) on the LAN VIP — no public destination — and `<spoke>-intra` lets members of the
bubble talk to each other. Both are created with `delete_default_rules = true`; the project's `default`
group is emptied by a one-shot `openstack` CLI step. A compute-only user can boot instances (even on
Ext-Net) but, with these groups, cannot reach the Internet except through the hub proxy.

Values of `slot_supernet_base`, `slot_transit_offset`, `hub_lan_vlan_id`, `hub_lan_cidr`,
`hub_lan_carp_ip` must match the hub deployment.

**Managed Kubernetes caveats.** (1) MKS clusters left on default CIDRs use `10.2.0.0/16` (pods, Free
plan), `10.240.0.0/13` (pods, Standard) and `10.3.0.0/16` (services, both): slots 2 and 3 collide with them
— on slot 3 the `kubernetes` ClusterIP *is* the spoke gateway (`10.3.0.1`) and Standard nodes lose their
gateway ~20 s after joining. The module refuses those slots by default; alternatively create clusters with
an `ipAllocationPolicy` outside `slot_supernet_base`. (2) MKS **Free** nodes keep a public port on `Ext-Net`
managed through the project's `default` group: with `strip_default_secgroup = true` they never leave
`INSTALLING`, and the mandatory rules expose SSH/NodePorts publicly — prefer the Standard plan in a 3‑AZ
region. Details and the hub allowances in `deployments/mono-vrack-lan-transit/docs/06-managed-services.md`.
