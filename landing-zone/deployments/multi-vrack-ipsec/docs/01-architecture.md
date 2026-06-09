# Architecture

## Reference diagram

The official landing zone diagram (customer perimeter, hub, spokes, shared services and management / security foundation):

![OVHcloud landing zones diagram](../../../docs/Schema%20Landing%20Zones.png)

*(Source file: `docs/Schema Landing Zones.png` at the repository root.)*

## Overview

The platform relies on:

- **Separate OVHcloud Public Cloud projects** (hub "Project #0", then one project per spoke).
- **vRack**: private network per project; VLAN networks for WAN, LAN and firewall HA synchronisation.
- **OVH gateway** (`ovh_cloud_project_gateway`) for Internet access / WAN routing on the Public Cloud side.
- **OPNsense in active / passive cluster** (CARP, dedicated HASYNC interface) in every bubble.
- **IPsec (IKEv2)** between hub and spoke, with **VTI** and routes to reach the spoke LANs from the hub.

The main modules of the repository:

- `modules/firewall/opnsense-ha` (role = `hub-ipsec`) — network, hub OPNsense instances, floating IP, CARP WAN VIP.
- `modules/firewall/opnsense-ha` (role = `spoke-ipsec`) — same logic on the spoke side, tunnel to the hub.

The deployments:

- `deployments/multi-vrack-ipsec/landing-zone` — **Day‑1**: hub + QA spoke.
- `deployments/multi-vrack-ipsec/spoke-template` — **Day‑2**: new spoke + API peering on the hub.

## Mermaid representation (diagram approximation)

The PNG diagram remains the visual reference; the diagram below reproduces its structure (without pictograms or graphical detail).

```mermaid
flowchart TB
  subgraph customerNIC ["Customer NIC"]
    subgraph hubProj ["Public Cloud Project 0 - Hub - vRack Hub"]
      subgraph vRack0 ["vRack Private Network 0"]
        Internet((Internet))
        FIP[Floating IP]
        NGW[Network Gateway Public Cloud]
        OPNh[OPNsense HA]
        InstH[Instances]
        Internet --- FIP
        FIP --- NGW
        NGW --- OPNh
        OPNh --- InstH
      end
      S3Hub["S3 Object Storage and Cold Archive"]
      DataAI["Data Platform and AI Endpoints"]
      MPR[Managed Private Registry]
    end

    subgraph spoke1 ["Project Spoke 1 - vRack Spoke 1"]
      subgraph vRack1 ["vRack Private Network 1"]
        OPN1[OPNsense HA]
        Inst1[Instances]
        VLANs1["Private Networks vlan 1, 2, X"]
        OPN1 --- Inst1
        OPN1 --- VLANs1
      end
      S3Spoke1["S3 and Cold Archive"]
    end

    subgraph spokeN ["Project Spoke N - vRack Spoke N"]
      subgraph vRackN ["vRack Private Network N"]
        OPNn[OPNsense HA]
        InstN[Instances]
        VLANsN["Private Networks vlan 1, 2, X"]
        OPNn --- InstN
        OPNn --- VLANsN
      end
      S3SpokeN["S3 and Cold Archive"]
    end

    OPNh <-->|"Secure IPsec / inter-vRack link"| OPN1
    OPNh <-->|"Secure IPsec / inter-vRack link"| OPNn
  end

  subgraph mgmt ["Management and Automation"]
    MUI["OVHcloud Manager, Horizon, API, CLI"]
    MIaC["OpenTofu, SDK"]
  end

  subgraph secLayer ["Security and Compliancy"]
    IAM[IAM]
    KMS["KMS, Secret Manager, Certificate Manager"]
    Logs[Logs Data Platform]
  end

  customerNIC -.-> mgmt
  customerNIC -.-> secLayer
```

## Logical diagram (application flow)

Typical traffic in a centralised model: workloads in the spoke LAN go to the hub (Internet egress or shared services at the hub).

```mermaid
flowchart LR
  subgraph spoke [Spoke]
    App[LAN applications]
    FWs[OPNsense HA]
    App --> FWs
  end
  subgraph hub [Hub]
    FWh[OPNsense HA]
    Shared["Hub shared services S3 / Data Platform / Registry"]
    Internet[Internet]
    FWh --> Shared
    FWh --> Internet
  end
  FWs -->|"IPsec / VTI"| FWh
```

## Points of attention

- **Uniqueness**: every spoke must have distinct **VLANs**, **CIDRs** and **`ipsec_reqid`** values to avoid collisions.
- **Single hub**: the spoke template assumes a hub is already deployed; the hub's OPNsense API credentials are generated at Day‑1 and reused for Day‑2 peering.
- **IPsec performance**: the crypto load depends on instance sizing (flavor) and OPNsense tuning — adjust based on your load tests.

## Cross references

- Cloud prerequisites: [OVH prerequisites](../../../docs/02-ovh-prerequisites.md).
- Deployment: [Day‑1](02-day1-landing-zone.md), [Day‑2](03-day2-spoke.md).
