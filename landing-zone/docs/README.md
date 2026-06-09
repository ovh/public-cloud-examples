# Documentation — OVHcloud landing zone (hub / spoke)

Cross-cutting documentation for both available architectures. Pick your architecture to reach the architecture-specific guides.

## Available architectures

| Architecture | Description | Documentation |
|--------------|-------------|---------------|
| **Multi-vRack + IPsec** | One vRack per bubble, IPsec/VTI tunnel between each spoke and the hub, OPNsense HA pair in every bubble. | [deployments/multi-vrack-ipsec/docs/](../deployments/multi-vrack-ipsec/docs/README.md) |
| **Mono-vRack + LAN transit** | A single shared vRack, OPNsense HA only at the hub, L2 connectivity through a transit VLAN. | [deployments/mono-vrack-lan-transit/docs/](../deployments/mono-vrack-lan-transit/docs/README.md) |
| **OPNsense HA — Existing project** | OPNsense HA pair in an existing Public Cloud project, without creating a vRack or a project. | [deployments/opnsense-ha-existing-project/](../deployments/opnsense-ha-existing-project/README.md) |

> **Looking for a complete, concrete walkthrough?** The **[OrbitalEdge SAS worked example](../examples/orbital-edge/)** is a fictional end-to-end deployment built on the **Mono-vRack + LAN transit** architecture (it is an example, not a fourth architecture). It is the best starting point for a newcomer.

## Common guides

These guides apply to all three architectures.

| Guide | Content |
|-------|---------|
| [01 — Vision and sovereignty](01-vision-and-sovereignty.md) | EU positioning, GDPR, why hub-spoke with a managed firewall. |
| [02 — OVH prerequisites](02-ovh-prerequisites.md) | API tokens, Public Cloud projects, regions, vRack. |
| [03 — Migration from hyperscalers](03-migration-from-hyperscalers.md) | AWS / Azure / GCP mappings. |
| [04 — OPNsense Cloud-Ready image](04-image-opnsense-cloud-ready.md) | Image origin and responsibility, manual rebuild. |
| [05 — Security and secrets management](05-security-and-secrets.md) | TF_VAR_*, remote state, OPNsense TLS, credential rotation. |

## Persona-based paths

| Role | Start with |
|------|------------|
| **New team member / first read** | [Worked example — OrbitalEdge SAS](../examples/orbital-edge/) |
| **Decision maker / compliance** | [01 — Vision and sovereignty](01-vision-and-sovereignty.md) |
| **Network / security architect** | Pick an architecture above, then read the Architecture guide for the chosen one |
| **Platform engineer** | [05 — Security and secrets](05-security-and-secrets.md), then [04 — OPNsense Cloud-Ready image](04-image-opnsense-cloud-ready.md), then [02 — OVH prerequisites](02-ovh-prerequisites.md), then the Day‑1 guide of the chosen architecture |
| **Engineer (new spoke)** | Day‑2 guide of the chosen architecture |
| **Engineer (existing project)** | [OPNsense HA — Existing project](../deployments/opnsense-ha-existing-project/README.md) |
| **Migration from AWS / Azure / GCP** | [03 — Migration from hyperscalers](03-migration-from-hyperscalers.md) |

## Repository

The IaC code (OpenTofu) lives at the root: modules under `modules/`, deployments under `deployments/`. See the [main README](../README.md) for quick commands.
