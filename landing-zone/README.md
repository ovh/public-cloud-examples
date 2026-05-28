# OVHcloud landing zone — Hub / Spoke (OPNsense)

Infrastructure as Code (**OpenTofu**) to deploy a **network landing zone** on **OVHcloud Public Cloud**: highly available **OPNsense** firewall at the **hub**, isolated **spokes** (dedicated projects), **centralised** security model. Two architectures are available: **IPsec/VTI** (one vRack per bubble) or **L2 LAN transit** (shared vRack, no firewall in the spokes).

![OVHcloud landing zone architecture diagram (hub / spoke)](docs/Schema%20one%20vRack%20LZ.png)

*Reference diagram: customer perimeter, hub project, spoke projects, vRack, shared services and management / security foundation.*

## Documentation

Documentation is organised by architecture in **[docs/](docs/README.md)**:

| Architecture | Description | Guides |
|--------------|-------------|--------|
| **Multi-vRack + IPsec** | One vRack per bubble, IPsec/VTI tunnel, OPNsense HA in every spoke. | [deployments/multi-vrack-ipsec/docs/](deployments/multi-vrack-ipsec/docs/README.md) |
| **Mono-vRack + LAN transit** | A single shared vRack, OPNsense HA at the hub only, L2 connectivity. | [deployments/mono-vrack-lan-transit/docs/](deployments/mono-vrack-lan-transit/docs/README.md) |

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

## Typical commands

**Multi-vRack — Day‑1**

```bash
cd deployments/multi-vrack-ipsec/landing-zone
tofu init && tofu apply
```

**Multi-vRack — Day‑2 spoke** (after copying the template and configuring `terraform.tfvars`)

```bash
cd deployments/multi-vrack-ipsec/spoke-template
tofu init && tofu apply
```

**Mono-vRack — Day‑1**

```bash
cd deployments/mono-vrack-lan-transit/landing-zone
tofu init && tofu apply
```

**Mono-vRack — Day‑2 spoke**

```bash
cd deployments/mono-vrack-lan-transit/spoke-template
tofu init && tofu apply
```

**Standalone OPNsense HA** (existing project, no vRack or project creation)

```bash
cd deployments/opnsense-ha-existing-project
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
tofu init && tofu apply
```

This project requires **OpenTofu** — HashiCorp Terraform is not compatible (state encryption not supported).

## Security and secrets

- Do not commit `terraform.tfvars` files containing passwords, PSKs or API keys.
- The **state** can contain sensitive data: use an encrypted **remote backend** with restricted access rights.
- The `hub_api_secret` outputs and similar must be retrieved carefully (`tofu output -raw` on a trusted machine).

## OPNsense / OVHcloud support

- OPNsense API and behaviour: [OPNsense documentation](https://docs.opnsense.org/).
- OVHcloud APIs and services: [OVHcloud documentation](https://help.ovhcloud.com/).
