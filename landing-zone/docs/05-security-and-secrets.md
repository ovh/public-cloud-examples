# 05 — Security and secrets management

## Core rule: never put secrets in files

> **⚠️ The `terraform.tfvars.example` files are reference documents.**
>
> They document the variable structure and provide typical values for network configuration. **They are not templates to be filled in with real credentials.** Never copy a sensitive value (password, API key, PSK, passphrase) into a `terraform.tfvars` file — even if that file is gitignored.

The rule is simple:

| Variable type | Where to put it |
|---------------|-----------------|
| Network configuration (region, VLAN, CIDR, flavor) | `terraform.tfvars` |
| Any secret (password, API key, PSK, passphrase) | `TF_VAR_*` environment variable |

---

## Recommended approach: `TF_VAR_*` environment variables

OpenTofu automatically reads any environment variable prefixed with `TF_VAR_` and injects it into the plan. This is the recommended method for secrets: they never touch the disk and cannot be committed by mistake.

### Sensitive variables that must never live in a file

| Variable | Description |
|----------|-------------|
| `TF_VAR_tofu_state_passphrase` | State encryption passphrase |
| `TF_VAR_ovh_application_key` | OVHcloud API application key |
| `TF_VAR_ovh_application_secret` | OVHcloud API application secret |
| `TF_VAR_ovh_consumer_key` | OVHcloud API Consumer Key |
| `TF_VAR_admin_password` | OPNsense admin password |
| `TF_VAR_ha_password` | CARP / xmlrpc HA password |
| `TF_VAR_ipsec_pre_shared_key` | IPsec PSK (multi-vRack only) |
| `TF_VAR_hub_api_key` | Hub OPNsense API key (Day-2 spoke) |
| `TF_VAR_hub_api_secret` | Hub OPNsense API secret (Day-2 spoke) |

### Example: manual deployment (multi-vRack landing zone)

```bash
# Secrets: injected from your secrets manager or entered interactively
export TF_VAR_tofu_state_passphrase="$(vault kv get -field=passphrase secret/tofu/lz)"
export TF_VAR_ovh_application_key="$(vault kv get -field=app_key secret/ovh/api)"
export TF_VAR_ovh_application_secret="$(vault kv get -field=app_secret secret/ovh/api)"
export TF_VAR_ovh_consumer_key="$(vault kv get -field=consumer_key secret/ovh/api)"
export TF_VAR_admin_password="$(vault kv get -field=admin_password secret/opnsense)"
export TF_VAR_ha_password="$(vault kv get -field=ha_password secret/opnsense)"
export TF_VAR_ipsec_pre_shared_key="$(vault kv get -field=psk secret/ipsec)"

# Network configuration only in terraform.tfvars
tofu apply
```

Your `terraform.tfvars` then contains only non-sensitive values:

```hcl
# terraform.tfvars — configuration only, no secrets
ovh_endpoint            = "ovh-eu"
compute_region          = "EU-WEST-PAR"
admin_client_ip         = "203.0.113.42"
hub_flavor              = "b3-16"
hub_net_wan_vlan_id     = 100
hub_private_wan_cidr    = "10.1.0.0/24"
# ...
```

### Example: CI/CD pipeline (GitLab CI, GitHub Actions, Drone)

Inject secrets from your vault or your CI platform's native secrets as `TF_VAR_*` environment variables. GitLab CI example:

```yaml
deploy:
  script:
    - tofu apply -auto-approve
  variables:
    TF_VAR_tofu_state_passphrase: $TOFU_STATE_PASSPHRASE   # secret GitLab CI
    TF_VAR_ovh_application_key: $OVH_APP_KEY
    TF_VAR_ovh_application_secret: $OVH_APP_SECRET
    TF_VAR_ovh_consumer_key: $OVH_CONSUMER_KEY
    TF_VAR_admin_password: $OPNSENSE_ADMIN_PASSWORD
    TF_VAR_ha_password: $OPNSENSE_HA_PASSWORD
    TF_VAR_ipsec_pre_shared_key: $IPSEC_PSK
```

---

## State: encryption and remote backend

### Local encryption (already in place)

Every deployment encrypts the state with AES-GCM via PBKDF2 (`encryption {}` block in `providers.tf`). The `terraform.tfstate` file is unreadable without the passphrase, even with physical access to the disk.

Pass the passphrase only through an environment variable:

```bash
export TF_VAR_tofu_state_passphrase="a-strong-passphrase"
```

### Remote backend (strongly recommended for teams)

By default, the state is stored locally. For a team this creates problems: state on a single workstation, no locking, risk of divergence. Add an OVHcloud S3 backend in `providers.tf`:

```hcl
terraform {
  backend "s3" {
    bucket                      = "my-tofu-state-bucket"
    key                         = "landing-zone/terraform.tfstate"
    region                      = "eu-west-par"
    endpoint                    = "https://s3.eu-west-par.io.cloud.ovh.net"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
  # The existing encryption {} block stays unchanged — the state remains client-side encrypted
}
```

S3 credentials are passed through `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables (or via `-backend-config`) — never in the code.

---

## OPNsense API: connection without TLS verification

### Why `insecure = true` and `curl -k`

At install time OPNsense generates a self-signed TLS certificate. The `restapi` provider and the `local-exec` `curl` calls cannot verify that certificate without a trusted CA or fingerprint.

### Mitigations already in place

- Port 8443 is only reachable from `admin_client_ip` (firewall rule injected into `config.xml`).
- Communication stays encrypted in transit (HTTPS); only the server's **identity** is not verified.

### How to harden

1. **Replace the self-signed certificate** with one issued by your internal PKI or Let's Encrypt (OPNsense ACME plugin), then remove `insecure = true` and `-k`.
2. **Restrict `admin_client_ip`** to a single fixed IP (not a /24).

---

## Credentials in system processes

The `local-exec` calls in `hub_peering.tf` build commands like `curl -u api_key:api_secret`. These credentials appear **briefly in the process list** (`ps aux`) on the machine running `tofu apply`.

**Mitigations:**

- Run `tofu apply` on a dedicated machine (IaC bastion, isolated CI runner) with restricted access.
- Do **not** set `TF_LOG=TRACE` or `TF_LOG=DEBUG` in production — these levels log HTTP bodies and would expose credentials in the logs.

---

## Credential rotation

| Secret | Procedure |
|--------|-----------|
| `admin_password` / `ha_password` | Change in the OPNsense UI → update `TF_VAR_*` (`user_data` is ignored after first boot) |
| `ipsec_pre_shared_key` | Update `TF_VAR_ipsec_pre_shared_key` → `tofu apply` (the `restapi` provider updates the PSK entry on the hub) — synchronise hub and spoke at the same time |
| `hub_api_key` / `hub_api_secret` | `tofu apply -replace=random_string.hub_api_key -replace=random_password.hub_api_secret` → `tofu apply` on the spoke to propagate |
| OVH API credentials | Revoke in the OVHcloud manager → generate a new set → update the environment variables |
| `tofu_state_passphrase` | Update `TF_VAR_tofu_state_passphrase` → `tofu apply` (the state is automatically re-encrypted with the new passphrase) |
