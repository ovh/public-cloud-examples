# Documentation — Multi-vRack + IPsec architecture

One vRack per bubble (hub + each spoke). Hub ↔ spoke interconnection runs over an **IPsec/VTI** tunnel with an OPNsense HA pair in every bubble.

## Persona-based paths

| Role | Start with |
|------|------------|
| **Network / security architect** | [01 — Architecture](01-architecture.md) |
| **Platform engineer (first deployment)** | [OVH prerequisites](../../../docs/02-ovh-prerequisites.md), then [02 — Day‑1 landing zone](02-day1-landing-zone.md) |
| **Engineer (new spoke)** | [03 — Day‑2 spoke](03-day2-spoke.md) |
| **Operations / SRE** | [04 — Lifecycle and operations](04-lifecycle-and-operations.md) |

## Guide contents

1. [Architecture](01-architecture.md) — Diagrams, traffic flows, components (OPNsense HA, vRack, IPsec/VTI).
2. [Day‑1 — Landing zone](02-day1-landing-zone.md) — Deploying `multi-vrack-ipsec/landing-zone`, outputs, users.
3. [Day‑2 — Spoke](03-day2-spoke.md) — Spoke template, duplication, hub peering, IPsec parameters.
4. [Lifecycle and operations](04-lifecycle-and-operations.md) — Destroy, hub cleanup, troubleshooting.

## Related deployments

| Path | Role |
|------|------|
| `deployments/multi-vrack-ipsec/landing-zone/` | Day‑1: hub + QA spoke (single `apply`). |
| `deployments/multi-vrack-ipsec/spoke-template/` | Day‑2: template to duplicate for each new spoke. |

## Operator constraints

- Each spoke must have distinct **VLANs**, **CIDRs** and **`ipsec_reqid`**.
- The hub must be deployed before any Day‑2 spoke.
- The hub's OPNsense API credentials are injected into the spoke's `terraform.tfvars`.
