# Vision and sovereignty

## Purpose of this landing zone

This repository models a **network landing zone** on **OVHcloud Public Cloud**: a secure **hub** (highly available OPNsense firewall) and isolated **spokes** (dedicated projects and networks), connected through **IPsec/VTI** or an **L2 transit VLAN** depending on the chosen architecture — a **centralised** security model (inspection and Internet egress at the hub).

## Sovereignty and trust

For organisations subject to **data localisation**, **subcontracting chain** or **geographic residency** requirements, the following criteria are often decisive:

- **European operator**: OVHcloud is a European company; contractual commitments and localisation options must be validated with your account manager and the [official OVHcloud documents](https://www.ovhcloud.com/fr/professional-services/certifications/).
- **Data inside the European Union**: explicitly choosing Public Cloud **regions** (datacentres) lets you host workloads and backups within the EU, subject to the effective configuration of the services used.
- **Network perimeter control**: a firewall **deployed and configured by you** (OPNsense) on dedicated infrastructure provides visibility and filtering rules **under your control**, without depending solely on a hyperscaler's "managed" security groups.

This repository is **not legal advice**. GDPR, NIS2, healthcare/finance and other obligations are the responsibility of your DPO and legal counsel.

## Why hub-spoke instead of a single large VPC?

- **Isolation**: each spoke can match a specific application, business unit or sensitivity tier.
- **Blast radius**: a compromise or misconfiguration is contained within the affected spoke.
- **Single policy at the hub**: Internet egress, inspection, logging, admin VPN can be enforced at the central point.

## Quick comparison with US hyperscalers

US clouds (AWS, Azure, GCP) provide mature services; choosing OVHcloud + a dedicated firewall typically reflects a mix of **perceived sovereignty**, **cost**, **proximity** and **perimeter simplicity** for European workloads. The trade-off is **higher operational responsibility** (OPNsense updates, backups, monitoring).

## What comes next

- Available architectures and implementation guides: [documentation index](README.md).
