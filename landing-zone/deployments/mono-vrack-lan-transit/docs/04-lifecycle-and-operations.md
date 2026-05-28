# Lifecycle and operations

## Add a spoke

1. Duplicate `deployments/mono-vrack-lan-transit/spoke-template` (or new workspace/Terragrunt).
2. Configure a **separate backend** — one state per spoke.
3. Pick unique values: `transit_router_ip`, VLAN IDs, CIDRs (see constraints in [Day‑2](03-day2-spoke.md)).
4. `tofu apply`.

## Remove a spoke

1. `tofu destroy` in the spoke directory.
   - Removes the Public Cloud project, the Neutron networks, and the OPNsense API objects (gateway + routes) through the `restapi` provider.
2. Verify in the hub OPNsense UI (`System → Routes`) that the spoke's gateway and routes are gone.

> The `restapi` provider is configured with `destroy_method = "POST"` — deletion of OPNsense objects goes through the `/del_*` API endpoints. When in doubt, verify manually in the UI.

## Full destroy (hub + every spoke)

1. Destroy **every spoke** first (required: the API routes must be removed while the hub is still reachable).
2. Destroy the hub (`tofu destroy` in `landing-zone/`) — removes the OPNsense instances, the vRack and the hub project.

> **Do not destroy the hub before the spokes.** Once the hub is destroyed, the `restapi` provider can no longer reach the OPNsense API to clean up the spoke objects.

## HA failover

The OPNsense pair uses CARP for the VIPs (WAN and LAN). When the primary node fails:

- The CARP VIP automatically swings to the secondary — the floating IP follows through the OVHcloud mechanism.
- Established connections survive thanks to pfsync synchronisation (state table).
- The configuration is replicated in real time via xmlrpc (dedicated HASYNC channel).

No manual action is required for a normal failover.

## OPNsense update

OPNsense updates are done from the WebGUI or via SSH — they do not go through Terraform. Update the secondary node first, test the failover, then update the primary.

## Hub sizing

Every inter-spoke and Internet-bound flow goes through the hub OPNsense pair. Adjust the flavor (`hub_flavor`) to your throughput needs:

| Flavor | vCPU | RAM | Indicative throughput |
|--------|------|-----|-----------------------|
| `b3-16` (default) | 4 | 16 GB | ≤ ~1 Gbps |
| `b3-64` | 16 | 64 GB | high traffic / many spokes |

Resizing the flavor requires a `tofu apply` with `taint` on the instances (or destroy/recreate of the hub module) — plan for a maintenance window.

## restapi troubleshooting

- *internal validation failed; object ID is not set* error: the OPNsense API returned `result: failed` without a UUID — usually a business validation issue (duplicate gateway, invalid CIDR, IP already in use).
- Enable `TF_LOG=TRACE` to see HTTP request/response bodies.
- The hub must be fully booted before the spoke `apply` — wait for the WebGUI to answer on `https://<hub_floating_ip>:8443`.

## Links

- Day‑1: [Landing zone](02-day1-landing-zone.md).
- Day‑2: [Spoke](03-day2-spoke.md).
