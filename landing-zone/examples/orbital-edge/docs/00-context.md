# 00 — Context and business needs

## OrbitalEdge SAS

OrbitalEdge SAS is a 45-person scale-up based in Paris, founded in 2021. It develops an edge computing and real-time analytics platform for LEO (Low Earth Orbit) satellite constellation operators. Its customers include space agencies, global telecom operators and environmental-monitoring players.

**Two products in production:**

**Constellation Manager** — multi-tenant SaaS platform that lets operators manage their satellite fleet: pass planning, health telemetry, mission re-tasking. Deployed on OVHcloud Managed Kubernetes.

**SignalVault** — pipeline that collects, deduplicates and long-term archives raw telemetry signals received by partner ground stations. Deployed on Linux instances (Python workers), OVHcloud managed PostgreSQL and Object Storage.

---

## Why a landing zone

### Regulatory constraints

OrbitalEdge processes operational data for customers covered by the NIS2 directive (critical-infrastructure operators). A documented security architecture, with a controlled network perimeter and isolation per application, is required during audits.

### Isolation and blast radius

An incident on Constellation Manager (e.g. compromise of a Kubernetes node) must not grant access to SignalVault data. Each application lives in its own OVHcloud Public Cloud project, with its own networks.

### Controlled Internet egress

SignalVault workers download files from partner ground stations through SFTP on fixed IPs. The centralised firewall lets us maintain an audited egress IP allowlist — impossible if each project managed its own Internet access.

### Data sovereignty

Customer telemetry data is subject to contractual clauses requiring EU localisation. OVHcloud, a European operator, with a Paris 3-AZ datacentre guaranteed in France, meets that constraint.

---

## Why mono-vRack

OrbitalEdge operates in a single region (`EU-WEST-PAR`, Paris). There is no multi-datacentre interconnection requirement for now. The mono-vRack model is the simplest: a single shared L2 plane, no IPsec tunnel to maintain, peering via OPNsense API automated by Terraform.

---

## Teams involved

| Team | Size | Responsibility in the LZ |
|---|---|---|
| Platform | 2 engineers | Deploys and operates the landing zone (hub + spokes) through IaC |
| FleetOS | 4 developers | Deploys Constellation Manager on the Kubernetes clusters |
| SignalVault | 3 engineers | Deploys the workers and consumes the managed services |
| Security | 1 CISO | Audits the firewall rules, signs off on network openings |

---

[01 — Architecture →](01-architecture.md)
