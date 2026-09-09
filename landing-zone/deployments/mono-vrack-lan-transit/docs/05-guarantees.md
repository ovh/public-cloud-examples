# Scope and shared responsibility

This page states what the landing zone enforces on its own, what the platform team configures with the
knobs provided, and what stays outside the design. Every line in the first table was measured on the
sandbox (GRA9 and EU‑WEST‑PAR, OPNsense 26.7, August 2026) with the identities the landing zone hands out.

## Enforced by the landing zone

| Property | Enforced by | Evidence |
|---|---|---|
| A workload team cannot create a public IP, a security group, a route or a network, nor disable port security | OpenStack role `compute_operator` only | all five refused with 403 |
| A workload with the provided groups has **no direct Internet path**, even with `Ext-Net` attached to the instance | security groups without any public destination (they follow the instance to every port) | probe on Ext-Net: `direct egress = BLOCKED`, proxy OK |
| An instance booted without a group has no connectivity | project `default` group emptied | probe never reached the metadata |
| Direct Internet traffic that reaches the hub is dropped and logged | hub policy, last rule | blocked attempts to `1.1.1.1:443` visible in the hub log |
| Inter-spoke traffic is decided at the hub | hub rules (ICMP allowed and logged, rest denied) | ping B→A OK, TCP/22 B→A blocked at the hub although both groups allowed it |
| Spokes may live in any region of the vRack | transit VLAN spans regions | spoke in EU‑WEST‑PAR served by the hub in GRA9 |
| Managed Kubernetes **Standard** (3‑AZ) — the data plane stays inside the bubble | one private port per node, no public address, egress through the hub | 3‑AZ cluster stable, image pulls through the hub |
| A `Service` of type `LoadBalancer` cannot publish a public address from a spoke | the spoke router has no external gateway | Octavia LB created privately, no Floating IP |
| The hub survives the loss of a node | CARP + pfsync + Floating IP on the CARP VIP | takeover immediate (7 lost 1‑second samples through the proxy), 34 s failback with one lost sample |
| Exposure drift is visible | `tools/audit-exposure.sh` with a read-only identity | an instance deliberately put on Ext-Net reported as `VIOLATION` |
| Billing and quotas follow the team | one Public Cloud project per spoke | native per-project billing and quotas; `GET /cloud/project/{id}/usage/current` readable by the team through IAM |

## Configured by the platform team

| Topic | Knob | Recommendation |
|---|---|---|
| Which Internet destinations workloads may reach | `proxy_allowed_domains` on the hub (squid allowlist); empty = any destination, always logged | start with the package mirrors and registries your teams need; widen on request through the pull-request workflow |
| Extra egress outside the proxy | `extra_egress` of the spoke (single address and port) | reachable through any port of the instance, without the proxy — keep it to managed-service endpoints |
| Managed services created through the OVHcloud API | IAM policy of the team identity on the spoke project | grant `database`, `loadbalancer`, `storage` explicitly and only when needed; do not grant `gateway/*` (a Gateway would add a public egress next to the hub); prefer private endpoints — see [06](06-managed-services.md) |
| Managed Kubernetes plan | `plan` at cluster creation | **Standard in a 3‑AZ region** for isolated workloads; **Free** (and mono‑AZ) keeps a public management port per node whose mandatory rules accept SSH and the NodePort range from the Internet — fine for labs, say so |
| Kubernetes API server | `ipRestrictions` and `openIdConnect` of the cluster | the API server is a public OVHcloud endpoint in every plan: restrict it to the hub's public address and the administrators, bind it to the company identity provider, forward audit logs — [06](06-managed-services.md) |
| Logs and metrics | `proxy_allowed_domains`, `proxy_connect_ports`, `hub_remote_syslog`; Service Logs subscriptions | Logs Data Platform through the existing paths (proxy for workloads, Service Logs for managed services, the hub in its own name) — [07](07-observability.md) |
| Slots | `slot` per spoke | 1..200 except 2 and 3 (default cluster ranges) — see [01](01-architecture.md) |
| Configuration sync between hub nodes | HA Status → *Synchronize* | on demand by design: sync after each change |
| Public attachment | audit | teams can still attach `Ext-Net` (no traffic); the audit lists it until IAM covers public attachment ([#1136](https://github.com/ovh/public-cloud-roadmap/issues/1136)) |

## Outside the design

- **The transit VLAN is operated by the platform team**: spoke routers and the hub share one L2 domain. The
  design isolates environments and teams of one organisation that trust their platform team; it is not a
  hard multi-tenant boundary between unrelated parties — use separate vRacks for that.
- Proxy connections do not survive a hub failover (squid terminates TCP); clients retry.
- Squid's own egress leaves with the router's public address, not the Floating IP; give both addresses to a
  partner who filters by source.
