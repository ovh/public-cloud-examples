# 03 — Day-1: hub deployment

## Context

Alice deploys the hub for the first time. This operation creates:
- The Public Cloud hub project (`hubonevrack-orb`)
- The shared vRack (`pn-123456`) — this name will be used by every spoke
- The OPNsense HA pair on two Paris availability zones (`eu-west-par-a` / `eu-west-par-b` or another pair drawn at random by `locals.tf`)
- The CARP WAN and LAN VIPs

This operation is done once. The vRack and the hub are shared by the 4 OrbitalEdge spokes.

## Prerequisites

- OVHcloud API tokens created with the scope described in [OVH prerequisites](../../../docs/02-ovh-prerequisites.md)
- OPNsense Cloud-Ready image built and available in the `EU-WEST-PAR` region — see [04 — OPNsense image](../../../docs/04-image-opnsense-cloud-ready.md)
- OpenTofu ≥ 1.11.4 installed on Alice's workstation or IaC runner
- Public IP of Alice's workstation known: `185.107.56.42` (OrbitalEdge Paris office)

## terraform.tfvars file (hub)

Alice starts from the committed template:

```bash
cd examples/orbital-edge/tofu/hub
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
```

Final content (after editing — `admin_client_ip` set to Alice's workstation IP):

```hcl
# examples/orbital-edge/tofu/hub/terraform.tfvars
# Configuration only. Secrets go through TF_VAR_* — see secrets.sh.example.

ovh_endpoint   = "ovh-eu"
compute_region = "EU-WEST-PAR"

# IP from which the OPNsense API (port 8443) is reachable.
# Restrict to a single fixed IP in production.
admin_client_ip = "185.107.56.42/32"

# Flavor b3-64: 16 vCPU, 64 GB RAM — sized for the cumulative traffic of the 4 spokes.
hub_flavor = "b3-64"

# Hub WAN — network between the OVHcloud Network Gateway and OPNsense.
hub_net_wan_vlan_id  = 100
hub_private_wan_cidr = "10.1.0.0/24"

# Hub LAN / Transit — VLAN shared with every spoke (never recreate with DHCP).
hub_net_lan_vlan_id  = 200
hub_private_lan_cidr = "192.168.10.0/24"

# Hub HASYNC — dedicated channel for CARP state replication between the two OPNsense nodes.
hub_net_hasync_vlan_id  = 199
hub_private_hasync_cidr = "10.0.254.0/30"

# Alice's public SSH key for OPNsense console access if needed.
ssh_public_key_path = "~/.ssh/id_ed25519.pub"
```

**Sensitive variables Alice injects from HashiCorp Vault before `tofu apply`:**

```bash
export TF_VAR_tofu_state_passphrase="$(vault kv get -field=passphrase secret/orbital-edge/tofu/lz)"
export TF_VAR_ovh_application_key="$(vault kv get -field=app_key secret/orbital-edge/ovh/api)"
export TF_VAR_ovh_application_secret="$(vault kv get -field=app_secret secret/orbital-edge/ovh/api)"
export TF_VAR_ovh_consumer_key="$(vault kv get -field=consumer_key secret/orbital-edge/ovh/api)"
export TF_VAR_admin_password="$(vault kv get -field=admin_password secret/orbital-edge/opnsense)"
export TF_VAR_ha_password="$(vault kv get -field=ha_password secret/orbital-edge/opnsense)"
```

## Deployment

```bash
cd examples/orbital-edge/tofu/hub
tofu init
tofu plan    # expect: 1 project, 1 vRack, 2 OPNsense instances, WAN/LAN/HASYNC networks
tofu apply
```

Expected duration: **5–8 minutes**.

The `EU-WEST-PAR` region is detected as 3-AZ by `locals.tf`. The two OPNsense nodes are placed in two separate availability zones drawn at random from `[eu-west-par-a/b]`, `[eu-west-par-a/c]` or `[eu-west-par-b/c]`. The choice is pinned in the state and does not change on subsequent applies.

## Outputs to keep

These values are needed for every Day-2 spoke. Alice stores them in Vault.

```bash
tofu output hub_vrack_service_name
# → pn-123456

tofu output hub_floating_ip
# → 51.195.42.7

tofu output hub_lan_carp_ip
# → 192.168.10.99

tofu output ssh_hub
# → ssh -i ~/.ssh/id_ed25519 root@51.195.42.7

tofu output https_hub
# → https://51.195.42.7:8443

# OPNsense API credentials (for the spokes)
tofu output -raw hub_api_key
# → a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6

tofu output -raw hub_api_secret
# → x7y8z9a0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v1w2
```

Alice stores these values in Vault:

```bash
vault kv put secret/orbital-edge/hub \
  vrack_service_name="pn-123456" \
  floating_ip="51.195.42.7" \
  lan_carp_ip="192.168.10.99" \
  api_key="a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6" \
  api_secret="x7y8z9a0b1c2d3e4f5g6h7i8j9k0l1m2n3o4p5q6r7s8t9u0v1w2"
```

## Post-deployment access

**OPNsense WebGUI:**

```
URL      : https://51.195.42.7:8443
User     : root
Password : (value of TF_VAR_admin_password)
```

The TLS certificate is self-signed at this stage — the browser will display a warning. Alice immediately creates a read-only `audit` account for Elena (CISO): `System → User Manager → Add`.

**SSH (emergency only):**

```bash
ssh -i ~/.ssh/id_ed25519 root@51.195.42.7
```

## vRack state after Day-1

```
vRack pn-123456
├── Hub project (hubonevrack-orb)
│   ├── VLAN 100 — WAN: 10.1.0.0/24
│   ├── VLAN 199 — HASYNC: 10.0.254.0/30
│   └── VLAN 200 — Transit/LAN: 192.168.10.0/24 (CARP VIP: .99)
└── (no spoke yet)
```

Ready for Day-2: spoke deployment.

---

← [02 — Governance](02-governance.md) | [04 — Day-2: Spokes →](04-day2-spokes.md)
