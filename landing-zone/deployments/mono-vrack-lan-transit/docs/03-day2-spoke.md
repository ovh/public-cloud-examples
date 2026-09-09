# Day‑2 — New spoke (template)

## Principle

Copy `deployments/mono-vrack-lan-transit/spoke-template` once per spoke, give it a **name** and a **slot**, paste the hub facts, apply. One state per spoke. **Nothing is done on the hub**: the route to the slot's supernet already exists there.

The spoke creates:

- A **Public Cloud project** attached to the hub vRack at order time.
- **Three identities**: `iac` (used by this template), `team` (compute only — the one you hand to the workload team) and `audit` (read only — for `tools/audit-exposure.sh`).
- The **networks** from `modules/network/spoke-slot`: transit port on the hub LAN VLAN, one LAN per entry of `networks`, a Neutron router with the hub VIP as default route, DHCP handing out the router and the hub DNS.
- The **security groups** `<spoke>-base` (metadata + hub services only) and `<spoke>-intra`; the project's `default` group is emptied.

## Prerequisites

- Day‑1 applied; `tofu output spoke_inputs` on the landing zone.
- A free slot number (1..`slot_count`, **not 2 or 3** — reserved, they are the default MKS pod/service ranges).

## Variables

| Variable | Example | Description |
|----------|---------|-------------|
| `spoke_name` | `finance-qa` | names the project and every resource |
| `slot` | `1` | the only uniqueness constraint: supernet `10.<slot>.0.0/16`, VLANs `1000+10·slot+n`, transit `.(10+slot)` |
| `networks` | `{ app = 0, db = 1 }` | LANs `10.<slot>.<n>.0/24` (n = 0..9) |
| `extra_egress` | `[]` | public whitelist added to `-base` (`cidr`, `port`, `protocol`); empty = proxy only |
| `hub_vrack_service_name`, `hub_lan_vlan_id`, `hub_lan_cidr`, `hub_lan_carp_ip`, `compute_region` | from `spoke_inputs` | hub facts |

## Commands

```bash
cp -r deployments/mono-vrack-lan-transit/spoke-template deployments/mono-vrack-lan-transit/spoke-finance-qa
cd deployments/mono-vrack-lan-transit/spoke-finance-qa
cp terraform.tfvars.example terraform.tfvars && $EDITOR terraform.tfvars   # name, slot, networks, hub facts
export TF_VAR_tofu_state_passphrase=…
tofu init && tofu apply
tofu output -json team_openrc     # hand this to the team (compute-only identity + HTTP_PROXY)
tofu output -json audit_openrc    # hand this to security
```

Duration: **3–5 minutes** (project order and delivery, then networks).

## Opening a flow — the pull-request workflow

Everything a team may need is a change to this directory, reviewed and applied by the platform team:

| Need | Change |
|---|---|
| a new Internet destination through the proxy | add the domain to `proxy_allowed_domains` on the landing zone (when the allowlist is enabled) |
| a public API without the proxy | `extra_egress = [{ cidr = "203.0.113.10/32", port = 443, protocol = "tcp" }]` |
| a second network | `networks = { app = 0, db = 1 }` |
| talk to spoke B | an egress rule here (B's supernet), an ingress rule on B's `-base`, and a hub rule allowing the protocol — the hub allows ICMP between spokes by default and denies the rest with a log entry |

## Checks

```bash
source <(tofu output -json audit_openrc | jq -r 'to_entries[] | "export \(.key)=\(.value)"')
../../../tools/audit-exposure.sh          # 0 instance on Ext-Net, 0 floating IP, default group empty
```

Boot a test instance with the `team` identity on the LAN with `-base`: it resolves names through the hub, pings the hub VIP, cannot reach the Internet directly, and reaches it through `http://<hub_lan_carp_ip>:3128`.
