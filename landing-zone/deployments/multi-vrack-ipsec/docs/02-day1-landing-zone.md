# Day‑1 — Landing zone deployment (hub + QA spoke)

## Role of this deployment

The `deployments/multi-vrack-ipsec/landing-zone` directory provisions:

- Two **Public Cloud projects** (hub and QA spoke) with a timestamped description (suffix `DDMMYYhhmm`).
- Two associated **vRacks** and **pauses** after attachment to let the OVH side propagate.
- OpenStack **admin** project users and **`compute_operator`** users (per-project "compute" limited role).
- The **`modules/firewall/opnsense-ha`** module (roles `hub-ipsec` and `spoke-ipsec`): networks, OVH WAN gateway, OPNsense HA instances, floating IP, IPsec configuration between hub and QA spoke.
- Generation of an **OPNsense API key / secret pair** (bcrypt hash injected into the hub config) for Day‑2 operations on the hub REST API.

## Prerequisites

- OVH variables filled in (see [OVH prerequisites](../../../docs/02-ovh-prerequisites.md)).
- A `terraform.tfvars` file for network configuration only (see `terraform.tfvars.example` for the structure) — **secrets must not live there**.
- Region, VLANs, CIDRs aligned with your network design.
- **Secrets**: read [05 — Security and secrets](../../../docs/05-security-and-secrets.md) before deploying — passwords, API keys and PSK go through `TF_VAR_*`.
- **OPNsense image**: this deployment uses an unofficial cloud-ready image — read [04 — OPNsense Cloud-Ready image](../../../docs/04-image-opnsense-cloud-ready.md) before deploying.

## Commands

```bash
cd deployments/multi-vrack-ipsec/landing-zone
tofu init
tofu plan
tofu apply
```


## Useful outputs

After `apply`, retrieve in particular:

| Output | Use |
|--------|-----|
| `hub_floating_ip` | Public admin / hub HTTPS API IP |
| `hub_wan_cidr` | Hub private WAN CIDR (spoke reference) |
| `hub_wan_carp_ip` | WAN CARP VIP — used as the local IPsec identity on the hub side and for Day‑2 peering |
| `spoke_qa_floating_ip` | QA spoke public IP |
| `hub_project_id` / `spoke_qa_project_id` | Project identifiers |

If your repository also exposes `hub_api_key` and `hub_api_secret` as outputs, use them for Day‑2. Otherwise, the values are generated in the OpenTofu state (`random_string.hub_api_key`, `random_password.hub_api_secret`): inspect them with `tofu state show 'random_string.hub_api_key'` and `tofu state show -json 'random_password.hub_api_secret'` (or add dedicated `output` blocks in `outputs.tf` without committing them in clear outside the team).

Examples:

```bash
tofu output hub_floating_ip
tofu output hub_wan_carp_ip
```

## Best practices

- **State**: use a remote backend (S3-compatible, OpenTofu Cloud, etc.) for the team; the state contains sensitive data.
- **Secrets**: do not put any password, API key or PSK in `terraform.tfvars` — use `TF_VAR_*` environment variables. See [05 — Security and secrets](../../../docs/05-security-and-secrets.md).
- **Consistency**: record `hub_wan_carp_ip`, `hub_private_wan_cidr` (variable) and the API key to feed the **spoke template** at Day‑2.

## What comes next

- New production spoke: [Day‑2 spoke](03-day2-spoke.md).
