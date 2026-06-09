# Documentation — Mono-vRack + LAN transit architecture

A single vRack shared across every bubble. Only the hub runs an OPNsense HA pair. Spokes connect to the hub through an **L2 transit VLAN**; routing is configured on the hub via the REST API.

## Persona-based paths

| Role | Start with |
|------|------------|
| **Network / security architect** | [01 — Architecture](01-architecture.md) |
| **Platform engineer (first deployment)** | [OVH prerequisites](../../../docs/02-ovh-prerequisites.md), then [02 — Day‑1 landing zone](02-day1-landing-zone.md) |
| **Engineer (new spoke)** | [03 — Day‑2 spoke](03-day2-spoke.md) |
| **Operations / SRE** | [04 — Lifecycle and operations](04-lifecycle-and-operations.md) |

## Guide contents

1. [Architecture](01-architecture.md) — Diagrams, traffic flows, transit VLAN, operator constraints.
2. [Day‑1 — Landing zone](02-day1-landing-zone.md) — Deploying `mono-vrack-lan-transit/landing-zone`, outputs, shared vRack.
3. [Day‑2 — Spoke](03-day2-spoke.md) — Spoke template, VLAN, subnets, hub API peering, routing.
4. [Lifecycle and operations](04-lifecycle-and-operations.md) — Destroy, HA failover, troubleshooting.

## Related deployments

| Path | Role |
|------|------|
| `deployments/mono-vrack-lan-transit/landing-zone/` | Day‑1: hub only (project + vRack + OPNsense HA). |
| `deployments/mono-vrack-lan-transit/spoke-template/` | Day‑2: template to duplicate for each new spoke. |

## Operator constraints (reminder)

- **Unique VLANs** per spoke — keep a manual registry of allocated VLANs.
- **Non-overlapping subnets** — all CIDRs must be disjoint.
- **Hub deployed before any Day‑2 spoke**.
