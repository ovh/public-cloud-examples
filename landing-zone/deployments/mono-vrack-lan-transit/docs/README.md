# Documentation — Mono-vRack + LAN transit (zero-trust)

One shared vRack. An OPNsense 26.7 HA pair at the hub only — DNS, NTP and an explicit proxy on its LAN VIP. Spokes are firewall-less Public Cloud projects identified by a **slot number**; their workloads live behind admin-curated security groups and can only reach the Internet through the hub proxy.

## Persona-based paths

| Role | Start with |
|------|------------|
| **Workload team** (you were handed a spoke) | [00 — For teams](00-for-teams.md) |
| **Decision maker / security** | [05 — Scope and shared responsibility](05-guarantees.md), then [01 — Architecture](01-architecture.md) |
| **Platform engineer (first deployment)** | [OVH prerequisites](../../../docs/02-ovh-prerequisites.md), then [02 — Day‑1 landing zone](02-day1-landing-zone.md) |
| **Platform engineer (new spoke)** | [03 — Day‑2 spoke](03-day2-spoke.md) |
| **Operations / SRE** | [04 — Lifecycle and operations](04-lifecycle-and-operations.md) |
| **Anyone planning Kubernetes, a managed database or S3 in a spoke** | [06 — Managed services](06-managed-services.md) |
| **Anyone wiring logs or metrics** | [07 — Observability](07-observability.md) |

## Guide contents

0. [For teams](00-for-teams.md) — the one page a workload team needs: what you get, what you can do, how to ask for more.
1. [Architecture](01-architecture.md) — slots, transit, hub services, the two policy layers, design choices and roadmap.
2. [Day‑1 — Landing zone](02-day1-landing-zone.md) — hub project, automatic vRack, OPNsense HA, post-boot.
3. [Day‑2 — Spoke](03-day2-spoke.md) — one slot, one apply, three identities.
4. [Lifecycle and operations](04-lifecycle-and-operations.md) — add/remove spokes, failover, audit, upgrades.
5. [Scope and shared responsibility](05-guarantees.md) — what the platform enforces, what you configure, what stays outside.
6. [Managed services](06-managed-services.md) — MKS, Managed Databases, S3 and LoadBalancer services in a spoke: what to configure, where the team's autonomy stops.
7. [Observability](07-observability.md) — logs out of the bubbles into Logs Data Platform: three paths, tenancy, what to set on the hub, what the roadmap changes.

## Related code

| Path | Role |
|------|------|
| `deployments/mono-vrack-lan-transit/landing-zone/` | Day‑1: hub project (vRack delivered with it), identities, OPNsense HA in hub mode, post-boot. |
| `deployments/mono-vrack-lan-transit/spoke-template/` | Day‑2: template to copy per spoke. |
| `modules/firewall/opnsense-ha` | OPNsense 26.7 HA (role `hub-simple`, `hub_services`, `slot_count`). |
| `modules/network/spoke-slot` | Spoke networks, router and zero-trust security groups from a slot number. |
| `tools/hub-postboot.sh`, `tools/audit-exposure.sh` | Day‑1 plugin sync; read-only exposure audit. |
