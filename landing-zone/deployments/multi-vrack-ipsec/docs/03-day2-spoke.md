# Day‑2 — New spoke (template)

## Principle

The `deployments/multi-vrack-ipsec/spoke-template` directory acts as a **template**: for each new spoke, **duplicate** the directory (or use a workspace / Terragrunt depending on your governance), adjust `terraform.tfvars` and use a **separate state** per spoke.

The spoke creates:

- A Public Cloud project, a vRack, users (including `compute_operator`).
- The spoke OPNsense infrastructure (`modules/firewall/opnsense-ha` module, role = `spoke-ipsec`).
- The **hub-side peering** through the **`restapi`** provider (OPNsense API): PSK, IKE connection, local/remote auth, child SA, VTI, IPsec reconfigure, VTI gateway, route to the spoke LAN, routing/routes reconfigure.

## Prerequisites

- Day‑1 hub deployed and reachable over HTTPS (`https://<hub_floating_ip>:8443`).
- Values from the landing-zone outputs: `hub_floating_ip`, `hub_wan_carp_ip`, `hub_private_wan_cidr` (hub WAN CIDR for consistency with the spoke), `hub_api_key`, `hub_api_secret`.
- A shared, strong **PSK**, identical on the hub side (via API) and on the spoke side (variable `ipsec_pre_shared_key`).

## Required uniqueness per spoke

| Parameter | Constraint |
|-----------|------------|
| `ipsec_reqid` | **Unique** per tunnel (e.g. 100, 101, …) — interface `ipsec<reqid>` on the hub |
| WAN / LAN / HASYNC VLAN | **Distinct** from other spokes |
| WAN / LAN / HASYNC / **VTI** CIDRs (`vti_link_cidr`) | **No overlap** with other spokes or with the hub |
| Project / vRack | One deployment = one state = one spoke |

## Configuration

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Fill in the OVH credentials, region, admin IP, passwords (aligned with your policy).
3. Fill in the hub references and the PSK.
4. Increment `ipsec_reqid` and adjust networks / VLANs.

## Commands

```bash
cd deployments/multi-vrack-ipsec/spoke-template   # or your renamed copy
tofu init
tofu plan
tofu apply
```

## Peering behaviour (summary)

- **`time_sleep`** delays: a pause after spoke cluster creation, then spacing between REST calls to reduce transient OPNsense rejections.
- JSON API keys: respect the **case** expected by OPNsense (e.g. VTI object as `vti`, not `VTI`).
- **Destroy**: the provider is configured with `destroy_method = "POST"` so that deletions via the OPNsense API are actually applied.

## In case of partial failure

If `apply` fails in the middle of the peering, objects may exist on the hub: clean up the matching IPsec entries / routes / gateway in the OPNsense UI or via API before re-running.

## What comes next

- Operations and destroy: [Lifecycle and operations](04-lifecycle-and-operations.md).
