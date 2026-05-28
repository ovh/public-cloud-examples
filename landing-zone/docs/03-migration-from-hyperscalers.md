# Migration from AWS, Azure and GCP — landmarks

This guide is **conceptual**: it helps teams familiar with hyperscalers find their bearings on an OVHcloud hub-spoke landing zone with OPNsense. It does not replace a migration study (network, identity, data, runbooks).

## Approximate mappings

| Hyperscaler concept | Counterpart in this repo / OVHcloud |
|---------------------|-------------------------------------|
| Account / subscription / cloud project | OVHcloud account + **Public Cloud projects** (multiple ones to isolate hub / spokes). |
| VPC / VNet / Google VPC | Isolation per **project** + **private networks** (vRack, OpenStack VLAN networks). |
| Internet Gateway / centralised NAT | **OVH gateway** on WAN + routing; filtered egress at the **hub** through your OPNsense rules. |
| Site-to-site VPN / Transit Gateway / Cloud VPN | **IPsec** between OPNsense instances (strongSwan); no single equivalent "managed VPN" service — **you operate** the firewall. |
| Security Groups / NSG / Firewall rules | **OPNsense** rules + OpenStack security groups depending on your design choices. |
| IAM roles per account | **OpenStack** users per project; **`compute_operator`** role for a limited scope; OVH **API** account for IaC. |
| CloudWatch / Monitor / Operations | To be wired up: OPNsense **logs / metrics** and OVHcloud monitoring depending on your tooling (Datadog, Prometheus, etc.). |

## Sovereignty and localisation

Customers leaving a **US** hyperscaler for Europe usually look for:

- localised **regions** and contracts;
- a European **provider**;
- less dependency on US-only services.

OVHcloud partly meets that expectation; **compliance** (GDPR, regulated sectors) remains a **case-by-case** analysis (where the data sits, who administers it, which subcontractors are involved).

## Strengths of the "OPNsense on IaaS" approach

- **Control**: you own the firewall, VPN, NAT, DNS forwarder, etc. configuration.
- **Portability**: OPNsense is a well-known on-premises product; skills transfer easily.
- **Cost**: often predictable (instances + floating IP + traffic) compared to a stack of managed services.

## Limitations

- **Operations**: patches, configuration backups, HA CARP — **your** responsibility.
- **No "managed firewall" SLA** by default: it's your software stack on IaaS.
- The **OPNsense API** integration in IaC (REST) requires rigour (JSON case, delays, destroy via POST).

## Project next steps

1. **Target network** workshop (CIDR, number of spokes, Internet exposure).
2. Pick **regions** and **flavors** (IPsec performance).
3. Migration **cutover plan** (identity reuse, DNS, VPN failover).
4. Hardening of **state** and **secrets** for the IaC team.

Technical documentation of the repository: [documentation index](README.md).
