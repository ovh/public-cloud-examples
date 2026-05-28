# 04 — Day-2: spoke deployment

## Deployment order

OrbitalEdge deploys the spokes in this order, making sure the hub is operational before each `apply`:

1. `constellation-dev`
2. `signalvault-dev`
3. `constellation-prod`
4. `signalvault-prod`

Each spoke is already pre-copied under `examples/orbital-edge/tofu/spoke-<name>/` and has its own Terraform state.

## Prerequisites common to every spoke

### IAM identities — pre-provisioned

Before any spoke `tofu apply`, the 4 IAM identities consumed by `iam.tf` (across all spokes) must already exist in the OVHcloud Manager — the OVH Terraform provider creates the policies but **not** the identities themselves. See the [pre-flight checklist](../README.md#before-you-start-manual-prerequisites) for creation instructions:

- Local user `camille.dubois` — consumed by `spoke-constellation-dev/iam.tf` and `spoke-constellation-prod/iam.tf`
- Local user `driss.el-fassi` — consumed by `spoke-signalvault-dev/iam.tf` and `spoke-signalvault-prod/iam.tf`
- Service account `sa-ci-constellation` — its OAuth2 login goes into `terraform.tfvars` (`iam_ci_service_account_login`) for both constellation spokes
- Service account `sa-ci-signalvault` — its OAuth2 login goes into `terraform.tfvars` for both signalvault spokes

Skipping this step makes the first spoke `tofu apply` fail.

### Secrets from Vault

Alice retrieves the hub values from Vault before each deployment:

```bash
HUB_VRACK=$(vault kv get -field=vrack_service_name secret/orbital-edge/hub)
HUB_FIP=$(vault kv get -field=floating_ip secret/orbital-edge/hub)
HUB_CARP=$(vault kv get -field=lan_carp_ip secret/orbital-edge/hub)
HUB_API_KEY=$(vault kv get -field=api_key secret/orbital-edge/hub)
HUB_API_SECRET=$(vault kv get -field=api_secret secret/orbital-edge/hub)

export TF_VAR_tofu_state_passphrase="$(vault kv get -field=passphrase secret/orbital-edge/tofu/lz)"
export TF_VAR_ovh_application_key="$(vault kv get -field=app_key secret/orbital-edge/ovh/api)"
export TF_VAR_ovh_application_secret="$(vault kv get -field=app_secret secret/orbital-edge/ovh/api)"
export TF_VAR_ovh_consumer_key="$(vault kv get -field=consumer_key secret/orbital-edge/ovh/api)"
export TF_VAR_hub_api_key="$HUB_API_KEY"
export TF_VAR_hub_api_secret="$HUB_API_SECRET"
```

---

## Spoke 1: constellation-dev

**Purpose:** dev Kubernetes cluster for the FleetOS team. Camille and her colleagues deploy the in-development versions of Constellation Manager on this spoke.

### Backend (optional)

The spoke is already present at `examples/orbital-edge/tofu/spoke-constellation-dev/`. If you use a remote backend, configure the Terraform backend in `providers.tf` with a dedicated state key:

```hcl
backend "s3" {
  key = "orbital-edge/constellation-dev/terraform.tfstate"
  # ... other S3 parameters unchanged
}
```

### terraform.tfvars

```bash
cd examples/orbital-edge/tofu/spoke-constellation-dev
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
```

Final content (after filling in the hub references from Vault):

```hcl
# examples/orbital-edge/tofu/spoke-constellation-dev/terraform.tfvars
# Configuration only. Secrets go through TF_VAR_* — see secrets.sh.example.

ovh_endpoint   = "ovh-eu"
compute_region = "EU-WEST-PAR"
spoke_name     = "constellation-dev"

# Hub references (landing-zone outputs)
hub_vrack_service_name = "pn-123456"
hub_floating_ip        = "51.195.42.7"
hub_lan_carp_ip        = "192.168.10.99"

# Transit VLAN — same as the hub, do not change
hub_lan_vlan_id   = 200
hub_lan_cidr      = "192.168.10.0/24"

# Spoke router IP on the transit — outside the hub DHCP pool (.100-.200)
transit_router_ip = "192.168.10.10"

# constellation-dev spoke LAN networks
networks = {
  "kube" = {
    vlan_id = 300
    cidr    = "10.30.0.0/24"
  }
}
```

### Deployment

```bash
cd examples/orbital-edge/tofu/spoke-constellation-dev
tofu init
tofu plan
tofu apply   # ~3 minutes
```

### VLAN registry after this spoke

| VLAN | Use | CIDR | Project |
|------|-----|------|---------|
| 200 | Transit | 192.168.10.0/24 | Hub |
| 300 | constellation-dev | 10.30.0.0/24 | constellation-dev |

### Outputs and handover to Camille

```bash
tofu output spoke_project_id
# → b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7

tofu output spoke_subnet_cidrs
# → { "kube" = "10.30.0.0/24" }
```

### Access handover

**Platform team — extract the OpenStack credentials from the state:**

```bash
# Username (non-sensitive)
tofu state show 'ovh_cloud_project_user.spoke_user' | grep username
# → user-a1b2c3d4

# Password (sensitive — store in Vault immediately)
tofu state show -json 'ovh_cloud_project_user.spoke_user' | jq -r '.values.password'
```

Alice stores these credentials in Vault for future `tofu apply` runs:

```bash
vault kv put secret/orbital-edge/constellation-dev/openstack \
  username="user-a1b2c3d4" \
  password="..."
```

**FleetOS team and CI/CD — IAM policies created by `iam.tf`:**

The `ovh_iam_policy` resources are provisioned during `tofu apply` (`iam.tf` file). Camille accesses the OVHcloud Manager directly with her existing IAM account — no OpenStack credentials need to be handed over. The CI pipeline uses its IAM service account.

> Reminder: `camille.dubois` and `sa-ci-constellation` must already exist in the OVHcloud Manager (see the [pre-flight checklist](../README.md#before-you-start-manual-prerequisites)).

---

## Spoke 2: signalvault-dev

**Purpose:** dev environment for the SignalVault team. Driss deploys Python workers that ingest test signals from staging ground stations.

This spoke has two networks: `app` (workers) and `data` (managed PostgreSQL, S3 endpoints). Driss deploys his workers in `app`; he does not deploy instances in `data` (it is a connectivity network to managed services, whose endpoints transit through the hub).

### Backend (optional)

```hcl
backend "s3" {
  key = "orbital-edge/signalvault-dev/terraform.tfstate"
}
```

### terraform.tfvars

```bash
cd examples/orbital-edge/tofu/spoke-signalvault-dev
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
```

```hcl
# examples/orbital-edge/tofu/spoke-signalvault-dev/terraform.tfvars
# Configuration only. Secrets go through TF_VAR_* — see secrets.sh.example.

ovh_endpoint   = "ovh-eu"
compute_region = "EU-WEST-PAR"
spoke_name     = "signalvault-dev"

hub_vrack_service_name = "pn-123456"
hub_floating_ip        = "51.195.42.7"
hub_lan_carp_ip        = "192.168.10.99"

hub_lan_vlan_id   = 200
hub_lan_cidr      = "192.168.10.0/24"

# IP distinct from constellation-dev (.10)
transit_router_ip = "192.168.10.11"

# Two networks: application workers + managed services connectivity
networks = {
  "app" = {
    vlan_id = 310
    cidr    = "10.31.0.0/24"
  }
  "data" = {
    vlan_id = 311
    cidr    = "10.31.1.0/24"
  }
}
```

### Deployment

```bash
cd examples/orbital-edge/tofu/spoke-signalvault-dev
tofu init
tofu plan
tofu apply
```

### Post-deployment hub firewall rules

After the `apply`, Alice configures the SignalVault-specific rules in the OPNsense UI:

- **Allow**: `10.31.0.0/24` (workers) → dev PostgreSQL endpoint `:5432`
- **Allow**: `10.31.0.0/24` → OVHcloud Object Storage `s3.eu-west-par.io.cloud.ovh.net` `:443`
- **Block**: `10.31.0.0/24` → `10.31.1.0/24` (the workers don't need to see the data network directly)

### VLAN registry after this spoke

| VLAN | Use | CIDR | Project |
|------|-----|------|---------|
| 200 | Transit | 192.168.10.0/24 | Hub |
| 300 | constellation-dev | 10.30.0.0/24 | constellation-dev |
| 310 | signalvault-dev app | 10.31.0.0/24 | signalvault-dev |
| 311 | signalvault-dev data | 10.31.1.0/24 | signalvault-dev |

### Outputs and handover to Driss

```bash
tofu output spoke_project_id
# → c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8

tofu output spoke_subnet_cidrs
# → { "app" = "10.31.0.0/24", "data" = "10.31.1.0/24" }
```

### Access handover

**Platform team:**

```bash
tofu state show 'ovh_cloud_project_user.spoke_user' | grep username
tofu state show -json 'ovh_cloud_project_user.spoke_user' | jq -r '.values.password'
# → store in Vault: secret/orbital-edge/signalvault-dev/openstack
```

**SignalVault team and CI/CD:** IAM policies (`iam.tf`) created during `tofu apply`. Driss accesses through his existing OVHcloud IAM account.

Alice also provisions the managed PostgreSQL instance in the `c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8` project (outside the spoke template — through the OVHcloud Manager or a dedicated Terraform module) and stores the connection string in Vault:

```bash
vault kv put secret/orbital-edge/signalvault-dev/db \
  endpoint="postgresql-dev.c3d4e5f6.database.cloud.ovh.net" \
  port="20184" \
  username="signalvault_app" \
  password="XXXX"
```

---

## Spoke 3: constellation-prod

**Purpose:** production Kubernetes cluster. Deployment identical to the dev spoke with distinct VLAN/CIDR and a distinct `transit_router_ip`.

```bash
cd examples/orbital-edge/tofu/spoke-constellation-prod
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
```

```hcl
# examples/orbital-edge/tofu/spoke-constellation-prod/terraform.tfvars
# Configuration only. Secrets go through TF_VAR_* — see secrets.sh.example.

ovh_endpoint   = "ovh-eu"
compute_region = "EU-WEST-PAR"
spoke_name     = "constellation-prod"

hub_vrack_service_name = "pn-123456"
hub_floating_ip        = "51.195.42.7"
hub_lan_carp_ip        = "192.168.10.99"

hub_lan_vlan_id   = 200
hub_lan_cidr      = "192.168.10.0/24"

transit_router_ip = "192.168.10.20"

networks = {
  "kube" = {
    vlan_id = 400
    cidr    = "10.40.0.0/24"
  }
}
```

Backend (optional):

```hcl
backend "s3" {
  key = "orbital-edge/constellation-prod/terraform.tfstate"
}
```

### Deployment

```bash
cd examples/orbital-edge/tofu/spoke-constellation-prod
tofu init
tofu plan
tofu apply
```

### Access handover

```bash
# Platform team
tofu state show 'ovh_cloud_project_user.spoke_user' | grep username
tofu state show -json 'ovh_cloud_project_user.spoke_user' | jq -r '.values.password'
# → store in Vault: secret/orbital-edge/constellation-prod/openstack
```

Camille's IAM policies + CI pipeline created by `iam.tf` during `tofu apply`.

---

## Spoke 4: signalvault-prod

```bash
cd examples/orbital-edge/tofu/spoke-signalvault-prod
cp terraform.tfvars.example terraform.tfvars
$EDITOR terraform.tfvars
```

```hcl
# examples/orbital-edge/tofu/spoke-signalvault-prod/terraform.tfvars
# Configuration only. Secrets go through TF_VAR_* — see secrets.sh.example.

ovh_endpoint   = "ovh-eu"
compute_region = "EU-WEST-PAR"
spoke_name     = "signalvault-prod"

hub_vrack_service_name = "pn-123456"
hub_floating_ip        = "51.195.42.7"
hub_lan_carp_ip        = "192.168.10.99"

hub_lan_vlan_id   = 200
hub_lan_cidr      = "192.168.10.0/24"

transit_router_ip = "192.168.10.21"

networks = {
  "app" = {
    vlan_id = 410
    cidr    = "10.41.0.0/24"
  }
  "data" = {
    vlan_id = 411
    cidr    = "10.41.1.0/24"
  }
}
```

Backend (optional):

```hcl
backend "s3" {
  key = "orbital-edge/signalvault-prod/terraform.tfstate"
}
```

### Deployment

```bash
cd examples/orbital-edge/tofu/spoke-signalvault-prod
tofu init
tofu plan
tofu apply
```

### Access handover

```bash
# Platform team
tofu state show 'ovh_cloud_project_user.spoke_user' | grep username
tofu state show -json 'ovh_cloud_project_user.spoke_user' | jq -r '.values.password'
# → store in Vault: secret/orbital-edge/signalvault-prod/openstack
```

Driss's IAM policies + CI pipeline created by `iam.tf` during `tofu apply`.

---

## Final VLAN registry — all spokes deployed

| VLAN | Use | CIDR | Project | transit_router_ip |
|------|-----|------|---------|-------------------|
| 100 | Hub WAN | 10.1.0.0/24 | Hub | — |
| 199 | Hub HASYNC | 10.0.254.0/30 | Hub | — |
| 200 | Shared transit | 192.168.10.0/24 | All | — |
| 300 | constellation-dev | 10.30.0.0/24 | constellation-dev | 192.168.10.10 |
| 310 | signalvault-dev app | 10.31.0.0/24 | signalvault-dev | 192.168.10.11 |
| 311 | signalvault-dev data | 10.31.1.0/24 | signalvault-dev | (same router) |
| 400 | constellation-prod | 10.40.0.0/24 | constellation-prod | 192.168.10.20 |
| 410 | signalvault-prod app | 10.41.0.0/24 | signalvault-prod | 192.168.10.21 |
| 411 | signalvault-prod data | 10.41.1.0/24 | signalvault-prod | (same router) |

Next available spoke: `192.168.10.30` / VLAN `500+`.

---

← [03 — Day-1: Hub](03-day1-hub.md) | [05 — Operations →](05-operations.md)
