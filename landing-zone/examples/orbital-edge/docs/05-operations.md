# 05 — Operations and lifecycle

## Add a spoke

Scenario: OrbitalEdge launches a new product, **TelemetryArchive**, for cold storage of historical data. Baptiste creates a 5th spoke.

**Step 1 — Reserve the network resources in the VLAN registry** (before touching Terraform):

```
Spoke : telemetry-archive-prod
transit_router_ip : 192.168.10.30
VLAN 510 : telemetry-archive app — 10.51.0.0/24
VLAN 511 : telemetry-archive data — 10.51.1.0/24
```

Check that no CIDR overlaps the existing registry ([01 — Architecture](01-architecture.md)).

**Step 2 — Create the spoke directory** by seeding from an existing orbital-edge spoke (closest match: `signalvault-prod`, which already has the `app` + `data` two-network shape):

```bash
cp -r examples/orbital-edge/tofu/spoke-signalvault-prod \
      examples/orbital-edge/tofu/spoke-telemetry-archive-prod
```

Then adapt `iam.tf` (identities / policy name), `providers.tf` (backend key), and `terraform.tfvars` to the new spoke.

**Step 3 — Fill in the tfvars and configure the backend:**

```hcl
# examples/orbital-edge/tofu/spoke-telemetry-archive-prod/terraform.tfvars
hub_vrack_service_name = "pn-123456"
hub_floating_ip        = "51.195.42.7"
hub_lan_carp_ip        = "192.168.10.99"
hub_lan_vlan_id        = 200
hub_lan_cidr           = "192.168.10.0/24"
transit_router_ip      = "192.168.10.30"

networks = {
  "app"  = { vlan_id = 510, cidr = "10.51.0.0/24" }
  "data" = { vlan_id = 511, cidr = "10.51.1.0/24" }
}
```

**Step 4 — Deploy:**

```bash
cd examples/orbital-edge/tofu/spoke-telemetry-archive-prod
tofu init && tofu apply
```

**Step 5 — Update the VLAN registry** in [01 — Architecture](01-architecture.md).

---

## Remove a spoke (end of dev environment)

Scenario: constellation-dev is no longer needed during a sprint-freeze window.

> **Important:** the spoke must be destroyed before the hub. If the hub is removed first, the `restapi` provider can no longer clean up the routes and gateways configured by the spoke on OPNsense.

```bash
cd examples/orbital-edge/tofu/spoke-constellation-dev
tofu destroy
```

Tofu deletes, in this order: the OPNsense static routes, the OPNsense gateway, the Neutron router, the networks, the Public Cloud project.

After `destroy`, free VLAN 300 and CIDR `10.30.0.0/24` in the registry.

---

## Incident: signalvault prod worker unreachable

Baptiste receives an alert: a worker `10.41.0.15` no longer answers from `10.41.0.0/24`.

**Debugging path:**

**1. Check connectivity from the hub**

```bash
# SSH to the primary OPNsense
ssh -i ~/.ssh/id_ed25519 root@51.195.42.7

# Ping from the hub to the worker
ping 10.41.0.15

# No reply → network issue or instance stopped
# Reply → application-level issue on the worker
```

**2. Check that the spoke static route is present on the hub**

In the OPNsense WebGUI: `System → Routes → Configuration`.

Look for an entry `10.41.0.0/24` with gateway `SpokeSignalvaultProdGW`. If missing:

```bash
cd examples/orbital-edge/tofu/spoke-signalvault-prod
tofu plan  # should show routes as "no changes" if state is consistent
tofu apply # recreates the OPNsense API objects if needed
```

**3. Check that the spoke Neutron router is active**

In the OVHcloud Manager → `signalvault-prod` project → Network → Routers: the router must be in `ACTIVE` state with one interface on the transit VLAN (`192.168.10.21`) and one on the `app` network (`10.41.0.0/24`).

**4. Check the OpenStack security groups**

An overly restrictive security group can block traffic without affecting routing:

```bash
# With the platform-team credentials
openstack security group list --project signalvault-prod
openstack security group rule list <sg-id>
```

**5. Check that the instance is running**

```bash
openstack server show 10.41.0.15 --project signalvault-prod
```

---

## OPNsense HA update

Service-uninterrupted update procedure, thanks to the HA pair.

**Step 1 — Identify the primary and secondary nodes**

In the WebGUI → `Lobby → Dashboard`: the active node shows `MASTER` in the CARP widget.

**Step 2 — Update the secondary node first**

```bash
# SSH to the secondary node
ssh -i ~/.ssh/id_ed25519 root@<secondary-node-ip>
# Trigger the update from the UI or the command line
```

After the secondary reboot, verify that it returns to `BACKUP`.

**Step 3 — Force a failover to test**

In the primary node's WebGUI: `System → High Availability → Status → Force failover`. Check that OrbitalEdge traffic swings over without interruption (the CARP VIP `192.168.10.99` migrates to the former secondary).

**Step 4 — Update the former primary (now secondary)**

Same procedure. Once rebooted, the cluster is up to date.

---

## OPNsense API credentials rotation

Scenario: Alice suspects an OPNsense API key leak (exposed in CI logs).

```bash
cd examples/orbital-edge/tofu/hub

# Force regeneration of the API credentials
tofu apply -replace=random_string.hub_api_key -replace=random_password.hub_api_secret
```

Then propagate the new credentials to every spoke:

```bash
# Retrieve the new values
NEW_KEY=$(tofu output -raw hub_api_key)
NEW_SECRET=$(tofu output -raw hub_api_secret)

# Update Vault
vault kv put secret/orbital-edge/hub api_key="$NEW_KEY" api_secret="$NEW_SECRET"

# Re-run each spoke to refresh the restapi providers
for spoke in spoke-constellation-dev spoke-signalvault-dev spoke-constellation-prod spoke-signalvault-prod; do
  cd examples/orbital-edge/tofu/$spoke
  export TF_VAR_hub_api_key="$NEW_KEY"
  export TF_VAR_hub_api_secret="$NEW_SECRET"
  tofu apply
  cd -
done
```

---

## Sizing: when to move from b3-64 → b3-128?

The `b3-64` hub (16 vCPU, 64 GB RAM) is sized for the current traffic. Monitor via the OPNsense WebGUI → `Reporting → Traffic`: if the outbound throughput regularly exceeds 800 Mbps or if the CPU exceeds 70% at peak load, migrate to `b3-128`.

A flavor migration requires replacing the instances (`tofu apply -replace=...`) with a CARP failover: destroy the secondary, recreate it with the new flavor, fail over, then repeat on the primary.

---

← [04 — Day-2: Spokes](04-day2-spokes.md)
