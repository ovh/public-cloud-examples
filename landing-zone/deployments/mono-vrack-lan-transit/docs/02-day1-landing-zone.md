# Day‑1 — Landing zone deployment (hub)

## Role of this deployment

The `deployments/mono-vrack-lan-transit/landing-zone` directory provisions:

- A hub **Public Cloud project** (`hubonevrack<suffix>`) with its OpenStack users.
- A **shared vRack** (`shared<suffix>`) to which the hub project is attached at creation — this vRack will then be used by every Day‑2 spoke.
- The **OPNsense HA** pair at the hub: WAN, LAN and HASYNC networks, two instances on separate AZs (3-AZ regions), public floating IP, WAN and LAN CARP VIPs, OPNsense API credential pair.

Spokes are not created at Day‑1 — they are added at Day‑2 through the spoke template.

## Prerequisites

- OVHcloud API credentials filled in (see [OVH prerequisites](../../../docs/02-ovh-prerequisites.md)).
- A `terraform.tfvars` file for network configuration only (see `terraform.tfvars.example` for the structure) — **secrets must not live there**.
- **No pre-existing vRack required** — it is created by this deployment.
- **Secrets**: read [05 — Security and secrets](../../../docs/05-security-and-secrets.md) before deploying — passwords and API keys go through `TF_VAR_*`.
- **OPNsense image**: this deployment uses an unofficial cloud-ready image — read [04 — OPNsense Cloud-Ready image](../../../docs/04-image-opnsense-cloud-ready.md) before deploying.

## Key variables

| Variable | Default | Description |
|----------|---------|-------------|
| `compute_region` | — | OVHcloud region (e.g. `EU-WEST-PAR`, `GRA11`) |
| `hub_flavor` | `b3-16` | OPNsense instance flavor |
| `hub_net_wan_vlan_id` | `100` | Hub WAN VLAN ID |
| `hub_private_wan_cidr` | `10.1.0.0/24` | Hub WAN CIDR |
| `hub_net_lan_vlan_id` | `200` | Hub LAN VLAN ID (= transit VLAN shared with spokes) |
| `hub_private_lan_cidr` | `192.168.10.0/24` | Hub LAN CIDR |
| `hub_net_hasync_vlan_id` | `199` | HASYNC VLAN ID |
| `hub_private_hasync_cidr` | `10.0.254.0/30` | HASYNC CIDR (2 IPs are enough) |
| `admin_client_ip` | — | IP allowed to reach the WebGUI and SSH |
| `admin_password` | — | OPNsense admin password |
| `ha_password` | — | Shared CARP / xmlrpc password |

> **Important:** the hub LAN VLAN ID and CIDR (`hub_net_lan_vlan_id` / `hub_private_lan_cidr`) define the **shared transit VLAN**. Every Day‑2 spoke must use exactly the same values.

## Commands

```bash
cd deployments/mono-vrack-lan-transit/landing-zone

# 1. Network configuration (non-sensitive values only)
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone

# 2. Inject secrets via environment variables (see ../../../docs/05-security-and-secrets.md)
export TF_VAR_tofu_state_passphrase="..."   # encrypts the state; reused on every later command
export TF_VAR_ovh_application_key="..."
export TF_VAR_ovh_application_secret="..."
export TF_VAR_ovh_consumer_key="..."
export TF_VAR_admin_password="..."
export TF_VAR_ha_password="..."

# 3. Deploy
tofu init
tofu plan
tofu apply
```

## Useful outputs

| Output | Use |
|--------|-----|
| `hub_project_id` | Hub project ID |
| `hub_vrack_service_name` | Shared vRack ID — **required for every Day‑2 spoke** |
| `hub_floating_ip` | Public admin IP and HTTPS API |
| `hub_lan_carp_ip` | LAN CARP VIP — default gateway for spokes |
| `hub_wan_carp_ip` | WAN CARP VIP |
| `ssh_hub` | Ready-to-use SSH command |
| `https_hub` | OPNsense WebGUI URL |

```bash
tofu output hub_vrack_service_name
tofu output hub_floating_ip
tofu output hub_lan_carp_ip
```

The OPNsense API credentials (generated in the state) are required for Day‑2 spokes:

```bash
tofu output hub_api_key
tofu output -raw hub_api_secret   # sensitive — only on a trusted workstation
```

> **Note:** `hub_api_key` and `hub_api_secret` are not exposed as `output` by default in this deployment (they live in the state under `random_string.hub_api_key` and `random_password.hub_api_secret`). You can inspect them with:
> ```bash
> tofu state show 'random_string.hub_api_key'
> tofu state show -json 'random_password.hub_api_secret' | jq -r '.values.result'
> ```

## Duration and behaviour

- **Typical duration:** 5–8 minutes (project + vRack creation + 30 s propagation wait + OPNsense instances).
- A 30 s `time_sleep` pause is inserted after the project/vRack attachment to let the OVH API propagate the state.
- In 3-AZ regions (`EU-WEST-PAR`, `EU-SOUTH-MIL`), the AZ pair is drawn at random on the first apply and pinned in the state.

## Best practices

- Use an encrypted **remote backend** for the state (the state contains passwords and API credentials).
- Do not put any password or API key in `terraform.tfvars` — use `TF_VAR_*` environment variables. See [05 — Security and secrets](../../../docs/05-security-and-secrets.md).
- Record `hub_vrack_service_name`, `hub_floating_ip`, `hub_lan_carp_ip` and the API credentials — they are required for every Day‑2 spoke.

## What comes next

- First spoke: [Day‑2 — New spoke](03-day2-spoke.md).
