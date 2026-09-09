# Lifecycle and operations

## Add a spoke

Copy the template, pick a free slot (never 2 or 3), apply ([Day‑2](03-day2-spoke.md)). No hub change. Record the slot.

## Remove a spoke

`tofu destroy` in the spoke directory removes the networks, the identities and the project (project termination is confirmed by the provider through the account's notification mails). The hub keeps its inert route to the slot; the slot can be reused once the project is gone.

## Extend the slots

Raise `slot_count` on the landing zone and apply: the hub's `user_data` is ignored after boot (`lifecycle.ignore_changes`), so push the new gateways/routes to the running pair with the OPNsense API (`routing/settings/add_gateway`, `routes/routes/addroute`, then `…/reconfigure`) or redeploy the hub in a maintenance window.

## Change the proxy allowlist, CONNECT ports or the hub's remote syslog

Edit `proxy_allowed_domains`, `proxy_connect_ports` or `hub_remote_syslog` in the landing-zone
`terraform.tfvars` and apply: the post-boot step re-runs and pushes the settings to both hub nodes through
the API (squid restarted, syslog reconfigured) — no instance is rebuilt (`user_data` changes are ignored on
running nodes). An empty allowlist restores "any destination"; `hub_remote_syslog = null` removes the
destination. Verified on the sandbox: allowed domain and sub-domains `200`, other domains `403`, HTTPS
`CONNECT` to other domains refused; ports and destination applied and removed on both nodes.

## HA failover — measured on the sandbox (GRA9, 2026‑08‑28)

| Event | Observed |
|---|---|
| primary stopped | Floating IP served by the secondary as soon as the instance was down; CARP MASTER on WAN and LAN; squid running on the secondary |
| 1‑second probe through the proxy | **7 lost samples**, then steady |
| 100 MB download in progress **through the proxy** | **cut** (`curl` error 56 after 27 MB) — an explicit proxy terminates TCP; its connections do not survive a node switch, pfsync or not |
| primary restarted | MASTER again after **34 s** (preemption), one lost sample |

Plan for it: clients retry (browsers, `apt`, most SDKs do); long transfers through the proxy should be resumable. Flows that only *route* through the hub (inter-spoke, DNS) do survive thanks to pfsync — measured at one lost second on the standalone deployment.

## Configuration sync between the two hub nodes

OPNsense replicates configuration **on demand**: after a change on the primary, push it from *System › High Availability › Status* or `POST /api/core/hasync_status/restart_all`. Firewall state (pfsync) is continuous.

## Audit

`tools/audit-exposure.sh`, run with a spoke's `audit` identity (read only), reports instances on `Ext-Net`, floating IPs, ports without port security, security groups outside the landing-zone set and rules left in `default`. Run it periodically per spoke; a `VIOLATION` line is a conversation to have with the team.

## Hub OPNsense upgrades

Minor updates: WebGUI or `opnsense-update` on the secondary first, test a failover, then the primary. Major version: rebuild the pair from a new cloud-ready image (`opnsense_version`) in a maintenance window — the module recreates the instances; spokes are untouched.

## Troubleshooting

- *Spoke instance has no connectivity at all* — booted without security group (default is empty) or without `-base`.
- *Instance reaches DNS but not the Internet* — no proxy configured on the client; direct egress is denied by design.
- *Proxy stopped after Day‑1* — re-run `tools/hub-postboot.sh` (installs missing plugins, normalises the proxy model, starts squid).
- *A new spoke cannot reach the hub VIP* — its slot number is above `slot_count`, or the hub LAN VLAN/CIDR differ from the hub.
- *Hub firewall log* — `Firewall › Log Files › Live View`: denied spoke flows carry the label *Zero-trust: everything else from the spokes is denied and logged*.

## Sizing

| Flavor | Indicative use |
|--------|----------------|
| `b3-16` (default) | up to ~1 Gbit/s routed, a few hundred proxy clients |
| `b3-64` | many spokes, heavy proxy use |
