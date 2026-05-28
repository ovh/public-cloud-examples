# OrbitalEdge — OpenTofu deployment

This directory contains the configuration files used to deploy the OrbitalEdge landing zone: an OPNsense HA hub and four spokes. Every component is a self-contained directory with its `.tf` files and its `terraform.tfvars`.

> The values (IPs, VLANs, credentials) are fictional. See [../docs/](../docs/) for the full context.

## Prerequisites

- OpenTofu ≥ 1.11.4
- OPNsense Cloud-Ready image available in the `EU-WEST-PAR` region — see [OPNsense image](../../../docs/04-image-opnsense-cloud-ready.md)
- **IAM identities created before the first spoke `tofu apply`**: each spoke's `iam.tf` references OVHcloud identities by their URN. These identities must exist beforehand in the OVHcloud Manager → *Identity and access management*:
  - Local users: `camille.dubois` (FleetOS team), `driss.el-fassi` (SignalVault team)
  - Service accounts: `sa-ci-constellation`, `sa-ci-signalvault` (GitLab CI pipelines)
  
  The OVH Terraform provider creates the *policies* but not the *identities* themselves.
- OVHcloud API tokens with the permissions described in [OVH prerequisites](../../../docs/02-ovh-prerequisites.md)

## Deployment workflow

### 1. Prepare the secrets

```bash
cp secrets.sh.example secrets.sh
# Fill secrets.sh with the actual values
source secrets.sh
```

### 2. Deploy the hub (Day-1)

```bash
cd hub/
tofu init
tofu apply
```

Duration: ~5–8 minutes. Capture the values to report into the spokes:

```bash
tofu output hub_vrack_service_name   # → report into every spoke terraform.tfvars
tofu output hub_floating_ip          # → same
tofu output hub_lan_carp_ip          # → 192.168.10.99 (default value)

# OPNsense API credentials (for the spokes)
tofu output -raw hub_api_key
tofu output -raw hub_api_secret
```

Report `hub_vrack_service_name` and `hub_floating_ip` into each spoke's `terraform.tfvars` (replace `REPLACE_ME`). Report `hub_api_key` and `hub_api_secret` into `secrets.sh`.

### 3. Deploy the spokes (Day-2)

Deploy in the order below to honour the VLAN registry:

```bash
cd spoke-constellation-dev/  && tofu init && tofu apply && cd ..
cd spoke-signalvault-dev/    && tofu init && tofu apply && cd ..
cd spoke-constellation-prod/ && tofu init && tofu apply && cd ..
cd spoke-signalvault-prod/   && tofu init && tofu apply && cd ..
```

Each spoke automatically configures routes on the hub OPNsense through the REST API.

### 4. Verification

In the OPNsense WebGUI (`https://<hub_floating_ip>:8443`):

- `System → Routes → Configuration`: 6 static routes expected (1 × constellation-dev, 1 × constellation-prod, 2 × signalvault-dev, 2 × signalvault-prod)
- `System → Gateways → Configuration`: 4 transit gateways expected

## VLAN registry

| VLAN | Use | CIDR | transit_router_ip |
|------|-----|------|-------------------|
| 100 | Hub WAN | 10.1.0.0/24 | — |
| 199 | Hub HASYNC | 10.0.254.0/30 | — |
| 200 | Shared transit | 192.168.10.0/24 | — |
| 300 | constellation-dev | 10.30.0.0/24 | 192.168.10.10 |
| 310 | signalvault-dev app | 10.31.0.0/24 | 192.168.10.11 |
| 311 | signalvault-dev data | 10.31.1.0/24 | (same router) |
| 400 | constellation-prod | 10.40.0.0/24 | 192.168.10.20 |
| 410 | signalvault-prod app | 10.41.0.0/24 | 192.168.10.21 |
| 411 | signalvault-prod data | 10.41.1.0/24 | (same router) |

---

## Why the .tf files are duplicated here

Each component contains a copy of the `.tf` files of the matching template (`deployments/mono-vrack-lan-transit/landing-zone/` or `spoke-template/`). This is intentional in this example: **zero external dependency**, `tofu init && tofu apply` works out-of-the-box, and the reader sees exactly what differentiates dev from prod.

**What it costs in production:**
- A fix in `hub_routing.tf` must be propagated to 4 copies manually
- The drift risk between spokes grows over time

**What we would use instead:**

To avoid duplication, the standard approach is **Terragrunt** — every component only has a `terragrunt.hcl` pointing to the template:

```hcl
# spoke-constellation-dev/terragrunt.hcl
terraform {
  source = "../../../deployments/mono-vrack-lan-transit/spoke-template"
}

inputs = {
  ovh_endpoint      = "ovh-eu"
  compute_region    = "EU-WEST-PAR"
  transit_router_ip = "192.168.10.10"
  networks = {
    "kube" = { vlan_id = 300, cidr = "10.30.0.0/24" }
  }
  # ...
}
```

```bash
cd spoke-constellation-dev && terragrunt apply
```

| Tool | Use case |
|---|---|
| **Terragrunt** (Gruntwork) | Industry reference, maximum DRY, inter-stack dependency management |
| **Terramate** | More modern stack approach, better DX, fast-growing |
| **Atmos** (Cloud Posse) | YAML-driven, widely used in AWS/enterprise LZs |
| **Native OpenTofu modules** | If the templates are refactored into modules — zero external dependency |

---

## Remote backend (production)

By default, the state is stored locally in each component directory. For a team, add an OVHcloud S3 backend in each `providers.tf`:

```hcl
terraform {
  backend "s3" {
    bucket   = "orbital-edge-tofu-state"
    key      = "hub/terraform.tfstate"   # distinct key per component
    region   = "eu-west-par"
    endpoint = "https://s3.eu-west-par.io.cloud.ovh.net"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
  # The existing encryption {} block stays unchanged
}
```

See [05 — Security and secrets](../../../docs/05-security-and-secrets.md) for the full procedure.
