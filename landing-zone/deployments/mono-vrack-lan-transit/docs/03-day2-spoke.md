# Day‑2 — New spoke (template)

## Principle

The `deployments/mono-vrack-lan-transit/spoke-template` directory acts as a **template**: for each new spoke, **duplicate** the directory (or use a workspace / Terragrunt depending on your governance), adjust `terraform.tfvars` and use a **separate state** per spoke.

The spoke creates:

- A dedicated **Public Cloud project**, attached to the existing shared vRack.
- The **spoke networks** through the `modules/network/spoke-one-vrack` module: transit VLAN (same L2 as the hub LAN), Neutron router with a default route to the hub CARP VIP, and one or more spoke LAN networks.
- The **hub-side peering** through the **`restapi`** provider (OPNsense API): a VTI gateway on the hub LAN interface pointing to the spoke Neutron router, then a static route per spoke LAN network.

## Prerequisites

- Day‑1 hub deployed and reachable over HTTPS (`https://<hub_floating_ip>:8443`).
- Values from the landing-zone outputs:

| Landing-zone output | spoke-template variable |
|---------------------|-------------------------|
| `hub_vrack_service_name` | `hub_vrack_service_name` |
| `hub_floating_ip` | `hub_floating_ip` |
| `hub_lan_carp_ip` | `hub_lan_carp_ip` |
| `hub_api_key` (state) | `hub_api_key` |
| `hub_api_secret` (state) | `hub_api_secret` |

## Required uniqueness per spoke

| Parameter | Constraint |
|-----------|------------|
| `transit_router_ip` | Free IP in the transit subnet (outside the hub DHCP pool `.10`–`.200`) — e.g. `192.168.10.10`, `192.168.10.11` … |
| `networks[*].vlan_id` | Unique VLAN IDs in the vRack (do not reuse 100, 199, 200 or those of other spokes) |
| `networks[*].cidr` | CIDRs disjoint from every other subnet in the vRack |

> The transit VLAN and CIDR (`hub_lan_vlan_id` / `hub_lan_cidr`) are **shared** between the hub and every spoke — they must **not** vary from one spoke to another.

## Key variables

| Variable | Default | Description |
|----------|---------|-------------|
| `compute_region` | — | OpenStack region of the spoke |
| `hub_vrack_service_name` | — | Shared vRack ID (landing-zone output) |
| `hub_floating_ip` | — | Hub public IP (landing-zone output) |
| `hub_lan_carp_ip` | — | Hub LAN CARP VIP = default gateway for spokes |
| `hub_lan_vlan_id` | `200` | Transit VLAN = hub LAN VLAN (do not change) |
| `hub_lan_cidr` | `192.168.10.0/24` | Transit CIDR = hub LAN CIDR (do not change) |
| `transit_router_ip` | `192.168.10.10` | Fixed IP of the spoke Neutron router on the transit |
| `networks` | see below | Map of spoke LAN networks (VLAN + CIDR) |

Example `networks` for a spoke with two networks:

```hcl
networks = {
  "app" = {
    vlan_id = 301
    cidr    = "10.30.1.0/24"
  }
  "db" = {
    vlan_id = 302
    cidr    = "10.30.2.0/24"
  }
}
```

## Commands

```bash
cp -r deployments/mono-vrack-lan-transit/spoke-template deployments/mono-vrack-lan-transit/spoke-<nom>
cd deployments/mono-vrack-lan-transit/spoke-<nom>
# Configure terraform.tfvars (separate backend recommended)
tofu init
tofu plan
tofu apply
```

## Outputs

| Output | Description |
|--------|-------------|
| `spoke_project_id` | Spoke project ID |
| `transit_router_ip` | IP of the spoke Neutron router on the transit VLAN |
| `spoke_subnet_cidrs` | LAN subnet CIDRs (map by network name) |
| `spoke_network_ids` | OpenStack LAN network IDs (map by network name) |

## Peering mechanism (summary)

1. **`module.spoke`** (spoke-one-vrack) creates the networks and the Neutron router with `transit_router_ip` as a fixed IP on the transit VLAN. The router's default route points to `hub_lan_carp_ip`.
2. **`restapi_object.hub_gateway`** creates a gateway on the hub OPNsense (interface `lan`, next-hop = `transit_router_ip`).
3. **`null_resource.hub_routing_reconfigure`** applies the routing configuration (`POST /api/routing/settings/reconfigure`).
4. **`restapi_object.hub_routes`** creates a static route per spoke LAN network (gateway = the gateway name created at step 2).
5. **`null_resource.hub_routes_reconfigure`** applies the routes (`POST /api/routes/routes/reconfigure`).

## In case of partial failure

If `apply` fails in the middle of the peering, objects may exist on the hub OPNsense. Clean up the matching gateways and routes in the OPNsense UI (`System → Routes → Gateway` / `Static`) or via API before re-running.

## What comes next

- Operations and destroy: [Lifecycle and operations](04-lifecycle-and-operations.md).
