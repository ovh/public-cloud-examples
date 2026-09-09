# Day‑1 — Landing zone deployment (hub)

## What it provisions

`deployments/mono-vrack-lan-transit/landing-zone` creates, in one `tofu apply`:

- The hub **Public Cloud project** (`hub<suffix>`). OVHcloud delivers a **vRack with it** a few minutes later; the deployment waits for it and reads its id — every spoke will join this vRack at order time.
- Two OpenStack identities: `hub_user` (IaC roles: compute, network, network security, image, volume) and a compute-only user.
- The **OPNsense 26.7 HA pair** in hub mode: WAN / LAN (= transit) / HASYNC networks, two instances (anti-affinity, separate AZs in 3‑AZ regions), Floating IP on the WAN CARP VIP, API credentials, **`slot_count` slots pre-routed**, unbound + ntpd + squid on the LAN VIP, zero-trust LAN policy.
- The **post-boot** step (`tools/hub-postboot.sh`): waits for the API, installs the plugins listed in the configuration (`os-squid`) on both nodes and starts the proxy. Idempotent.

## Prerequisites

- OVHcloud API access for the platform owner: the classic triplet (`TF_VAR_ovh_*`) **or** a service account (`OVH_CLIENT_ID` / `OVH_CLIENT_SECRET`) with an IAM policy allowing, on the account, `account:apiovh:me/get`, `account:apiovh:me/order/*`, `account:apiovh:me/payment/method/get`, `order:apiovh:cart/*` (and `account:apiovh:me/notification/email/history/get` if you want `tofu destroy` to terminate projects), plus `publicCloudProject:apiovh:*` and `vrack:apiovh:*` on **all resources of those types** (wildcard URNs — resource groups are static lists and never include what you create later). Details in [OVH prerequisites](../../../docs/02-ovh-prerequisites.md).
- A default payment method on the account (the provider checks it before ordering).
- Secrets through `TF_VAR_*` — see [05 — Security and secrets](../../../docs/05-security-and-secrets.md).
- The OPNsense cloud-ready image — read [04 — OPNsense Cloud-Ready image](../../../docs/04-image-opnsense-cloud-ready.md).

## Key variables

| Variable | Default | Description |
|----------|---------|-------------|
| `compute_region` | `EU-WEST-PAR` | OVHcloud region — the project ships with every region enabled; no region is added by the stack |
| `hub_flavor` | `b3-16` | OPNsense flavor — all Internet and inter-spoke traffic goes through it |
| `opnsense_version` | `26.7` | cloud-ready image release |
| `slot_count` | `20` | spoke slots pre-routed on the hub (gateway + route objects, free); raise later with a new apply |
| `hub_services` | `true` | DNS / NTP / explicit proxy on the LAN VIP and zero-trust policy; `false` gives a plain routing hub with *LAN to any* |
| `proxy_allowed_domains` | `[]` | domain suffixes the proxy lets workloads reach (`["ubuntu.com", "docker.io"]`); empty = any destination, always logged |
| `proxy_connect_ports` | `[443]` | ports the proxy tunnels with CONNECT; add `6514`, `12202` for log shippers → Logs Data Platform ([07](07-observability.md)) |
| `hub_remote_syslog` | `null` | `{ host, port }` of a TLS syslog receiver (LDP dedicated input) for the hub's own logs; applied by the post-boot step on both nodes |
| `admin_client_ip` | — | operator IP/CIDR allowed on 8443/22 (`AdminClients` alias) |
| `ssh_public_key_path` | `null` | operator key; if null a key is generated in `landing-zone/.ssh/hub_key` (git-ignored) — the post-boot step needs it to reach the secondary |
| `hub_net_lan_vlan_id` / `hub_private_lan_cidr` | `200` / `192.168.10.0/24` | **transit** VLAN and subnet — every spoke uses the same values |
| `hub_private_wan_cidr`, `hub_private_hasync_cidr` | `172.16.0.0/24`, `172.16.254.0/30` | keep outside `10.0.0.0/8` (spoke slots) |

## Commands

```bash
cd deployments/mono-vrack-lan-transit/landing-zone
cp terraform.tfvars.example terraform.tfvars && $EDITOR terraform.tfvars
export TF_VAR_tofu_state_passphrase=… TF_VAR_admin_password=… TF_VAR_ha_password=…
tofu init && tofu apply
```

Duration: **10–15 minutes** — project order (~1 min), vRack delivery wait (4 min), Keystone catalog of
the fresh project (the stack waits until it answers consistently, usually under a minute, occasionally
several), instances and double boot (~4 min), plugin installation (~2 min per node; the post‑boot step only
returns once squid answers on both nodes).

If a first apply is interrupted and a retry fails with `No suitable endpoint could be found in the service
catalog`, the catalog of the new project is still converging: wait a few minutes and run `tofu apply` again.

## Outputs

| Output | Use |
|--------|-----|
| `spoke_inputs` | everything a Day‑2 spoke needs: vRack, transit VLAN/CIDR, hub VIP, slot count, region — copy into each spoke's `terraform.tfvars` |
| `hub_floating_ip`, `https_hub`, `ssh_hub` | administration |
| `hub_lan_carp_ip` | LAN VIP: default gateway of spoke routers, DNS/NTP/proxy address |
| `hub_api_key`, `hub_api_secret` (sensitive) | OPNsense REST API |

## After the apply

- Check the hub: `https://<hub_floating_ip>:8443` → *Services › Squid* running, *Firewall › Rules › LAN* shows the zero-trust set, *System › Gateways* lists `SlotGW01…`.
- If the post-boot step failed (API not up in time), simply re-run it: `API_AUTH=$(tofu output -raw hub_api_key):$(tofu output -raw hub_api_secret) ../../../tools/hub-postboot.sh <fip> <hasync .2> <ssh key>`.
- Record the used slots as you create spokes.
