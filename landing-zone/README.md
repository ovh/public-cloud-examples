# OVHcloud landing zone — Hub / Spoke (OPNsense)

Infrastructure as Code (**OpenTofu**) to deploy a **network landing zone** on **OVHcloud Public Cloud**: highly available **OPNsense** firewall at the **hub**, isolated **spokes** (dedicated projects), **centralised** security model. Two network architectures are available — **IPsec/VTI** (one vRack per bubble) or **L2 LAN transit** (shared vRack, no firewall in the spokes) — plus a **standalone OPNsense-HA** option to drop a firewall pair into an existing project.

![OVHcloud landing zone architecture diagram (hub / spoke)](docs/Schema%20one%20vRack%20LZ.png)

*Reference diagram: customer perimeter, hub project, spoke projects, vRack, shared services and management / security foundation.*

## Worked example — start here

New to this project? The fastest way to understand it end to end is the **[OrbitalEdge SAS worked example](examples/orbital-edge/)** — a complete, fictional but consistent deployment of a French scale-up. It uses the **Mono-vRack + LAN transit** template **unchanged**; only the `terraform.tfvars` files differ.

It walks through the full lifecycle: [context and needs](examples/orbital-edge/docs/00-context.md) → [architecture](examples/orbital-edge/docs/01-architecture.md) → [governance and identities](examples/orbital-edge/docs/02-governance.md) → [Day-1 hub](examples/orbital-edge/docs/03-day1-hub.md) → [Day-2 spokes](examples/orbital-edge/docs/04-day2-spokes.md) → [operations](examples/orbital-edge/docs/05-operations.md), with ready-to-apply `tofu/` trees for the hub and four spokes.

## Documentation

Documentation is organised by architecture in **[docs/](docs/README.md)**:

| Architecture | Description | Guides |
|--------------|-------------|--------|
| **Multi-vRack + IPsec** | One vRack per bubble, IPsec/VTI tunnel, OPNsense HA in every spoke. | [deployments/multi-vrack-ipsec/docs/](deployments/multi-vrack-ipsec/docs/README.md) |
| **Mono-vRack + LAN transit** | A single shared vRack, OPNsense HA at the hub only, L2 connectivity. | [deployments/mono-vrack-lan-transit/docs/](deployments/mono-vrack-lan-transit/docs/README.md) |
| **Worked example (OrbitalEdge SAS)** | Complete fictional end-to-end deployment built on the Mono-vRack template (hub + 4 spokes). | [examples/orbital-edge/](examples/orbital-edge/README.md) |

Common guides (vision, OVH prerequisites, hyperscaler migration): **[docs/](docs/README.md)**.

## Quick prerequisites

- [OpenTofu](https://opentofu.org/) — required (state encryption uses an OpenTofu feature not available in HashiCorp Terraform).
- **OVHcloud API** credentials: Application Key, Application Secret, Consumer Key (see [docs/02-ovh-prerequisites.md](docs/02-ovh-prerequisites.md)).
- **Public Cloud** access and the ability to create projects, vRacks and OpenStack users.

## Repository layout

| Path | Role |
|------|------|
| `deployments/multi-vrack-ipsec/landing-zone/` | Multi-vRack — Day‑1: hub + QA spoke. |
| `deployments/multi-vrack-ipsec/spoke-template/` | Multi-vRack — Day‑2: new-spoke template. |
| `deployments/mono-vrack-lan-transit/landing-zone/` | Mono-vRack — Day‑1: hub only. |
| `deployments/mono-vrack-lan-transit/spoke-template/` | Mono-vRack — Day‑2: new-spoke template. |
| `deployments/opnsense-ha-existing-project/` | Standalone OPNsense HA in an existing project. |
| `modules/firewall/opnsense-ha/` | OPNsense HA module (roles: hub-simple, hub-ipsec, spoke-ipsec). |
| `modules/network/spoke-one-vrack/` | Firewall-less spoke network (mono-vRack). |
| `modules/storage/` | Storage module (use as needed). |
| `examples/orbital-edge/` | End-to-end worked example (OrbitalEdge SAS): hub + 4 spokes on the Mono-vRack template. |

## Typical commands

### Before you apply — set your secrets (one-time, per shell)

Every deployment **encrypts its OpenTofu state** with a passphrase. 

Secrets (passphrase, OVH API credentials, OPNsense passwords, IPsec PSK) are **not** stored in
`terraform.tfvars`. Export them as `TF_VAR_*` environment variables in your shell first:

```bash
# State encryption (asked for at apply time if unset)
export TF_VAR_tofu_state_passphrase="a-strong-passphrase"

# OVH API credentials — https://api.ovh.com/createToken/
export TF_VAR_ovh_application_key="..."
export TF_VAR_ovh_application_secret="..."
export TF_VAR_ovh_consumer_key="..."

# OPNsense accounts (and IPsec PSK on the multi-vRack architecture)
export TF_VAR_admin_password="..."
export TF_VAR_ha_password="..."
export TF_VAR_ipsec_pre_shared_key="..."   # multi-vRack only
```

`cp terraform.tfvars.example terraform.tfvars` then edit the **non-secret** values only —
region, instance flavor, VLAN IDs, CIDRs, `ssh_public_key_path` and `admin_client_ip` (the IP
or CIDR allowed to reach the OPNsense WebGUI/SSH — prefer a single fixed IP). The full procedure
is in [docs/05-security-and-secrets.md](docs/05-security-and-secrets.md).

**Multi-vRack — Day‑1** — guide: [deployments/multi-vrack-ipsec/docs/02-day1-landing-zone.md](deployments/multi-vrack-ipsec/docs/02-day1-landing-zone.md)

```bash
cd deployments/multi-vrack-ipsec/landing-zone
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone
tofu init && tofu apply
```

**Multi-vRack — Day‑2 spoke** — guide: [deployments/multi-vrack-ipsec/docs/03-day2-spoke.md](deployments/multi-vrack-ipsec/docs/03-day2-spoke.md)

```bash
cd deployments/multi-vrack-ipsec/spoke-template
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone
tofu init && tofu apply
```

**Mono-vRack — Day‑1** — guide: [deployments/mono-vrack-lan-transit/docs/02-day1-landing-zone.md](deployments/mono-vrack-lan-transit/docs/02-day1-landing-zone.md)

```bash
cd deployments/mono-vrack-lan-transit/landing-zone
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone
tofu init && tofu apply
```

**Mono-vRack — Day‑2 spoke** — guide: [deployments/mono-vrack-lan-transit/docs/03-day2-spoke.md](deployments/mono-vrack-lan-transit/docs/03-day2-spoke.md)

```bash
cd deployments/mono-vrack-lan-transit/spoke-template
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone
tofu init && tofu apply
```

**Standalone OPNsense HA** (existing project, no vRack or project creation) — guide: [deployments/opnsense-ha-existing-project/README.md](deployments/opnsense-ha-existing-project/README.md)

```bash
cd deployments/opnsense-ha-existing-project
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone
tofu init && tofu apply
```

This project requires **OpenTofu** — HashiCorp Terraform is not compatible (state encryption not supported).

## Cleanup

These deployments create billable resources (instances, vRacks, floating IPs). To avoid ongoing
cost, tear them down with `tofu destroy` — **destroy spokes before the hub**. The exact order and
API-side cleanup steps are documented per architecture:

- Multi-vRack: [deployments/multi-vrack-ipsec/docs/04-lifecycle-and-operations.md](deployments/multi-vrack-ipsec/docs/04-lifecycle-and-operations.md)
- Mono-vRack: [deployments/mono-vrack-lan-transit/docs/04-lifecycle-and-operations.md](deployments/mono-vrack-lan-transit/docs/04-lifecycle-and-operations.md)
- Standalone OPNsense HA: [deployments/opnsense-ha-existing-project/README.md](deployments/opnsense-ha-existing-project/README.md)

Run `tofu destroy` with the same `TF_VAR_tofu_state_passphrase` exported, otherwise the encrypted
state cannot be read.

## Security and secrets

- Do not commit `terraform.tfvars` files containing passwords, PSKs or API keys.
- The **state** can contain sensitive data: use an encrypted **remote backend** with restricted access rights.
- The `hub_api_secret` outputs and similar must be retrieved carefully (`tofu output -raw` on a trusted machine).

## OPNsense / OVHcloud support

- OPNsense API and behaviour: [OPNsense documentation](https://docs.opnsense.org/).
- OVHcloud APIs and services: [OVHcloud documentation](https://help.ovhcloud.com/).
