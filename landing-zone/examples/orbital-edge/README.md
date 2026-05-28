# Example: OrbitalEdge SAS — Mono-vRack landing zone

> **This example is entirely fictional.** Personal names, OVHcloud identifiers, public IP addresses and API keys are made up for teaching purposes. The network values (VLAN, CIDR) are real and consistent with each other.

OrbitalEdge SAS is a fictional French scale-up providing edge computing and real-time analytics for LEO satellite constellation operators. This example illustrates how such an organisation deploys a hub-spoke landing zone on OVHcloud Public Cloud using the [mono-vRack + LAN transit](../../deployments/mono-vrack-lan-transit/) template.

## Before you start: manual prerequisites

Each spoke's `iam.tf` creates `ovh_iam_policy` resources that reference IAM identities by URN. **The OVH Terraform provider creates the *policies* but not the *identities* themselves** — they must be pre-provisioned by hand in the OVHcloud Manager before any `tofu apply` on a spoke. Without this step, the spoke `apply` fails with a missing-identity error (or, worse, succeeds with a dangling URN that the runtime cannot authenticate).

Create the following 4 identities in the OVHcloud Manager → *Identity and access*:

| # | Identity | Type | Where in the Manager | Consumed by |
|---|----------|------|----------------------|-------------|
| 1 | `camille.dubois` | Local user | *Local users* | FleetOS team — access to `constellation-dev`, `constellation-prod` |
| 2 | `driss.el-fassi` | Local user | *Local users* | SignalVault team — access to `signalvault-dev`, `signalvault-prod` |
| 3 | `sa-ci-constellation` | Service account | *Service accounts* | Constellation GitLab CI pipeline (both envs) |
| 4 | `sa-ci-signalvault` | Service account | *Service accounts* | SignalVault GitLab CI pipeline (both envs) |

For each **service account** (rows 3 and 4), capture the **OAuth2 login** displayed next to the account name (form: `oauth2-EU.xxxxxxxxxxxxxxxx`). It can also be fetched via `GET /me/api/oauth2/client`. Pass it via the `iam_ci_service_account_login` variable in each spoke's `terraform.tfvars`.

See [02 — Governance and identities](docs/02-governance.md) for the rationale and [04 — Day-2: spoke deployment](docs/04-day2-spokes.md#prerequisites-common-to-every-spoke) for where these identities are consumed.

## Guides

| Document | Audience |
|---|---|
| [00 — Context and needs](docs/00-context.md) | Decision maker, architect, new team member |
| [01 — Architecture](docs/01-architecture.md) | Network architect, platform engineer |
| [02 — Governance and identities](docs/02-governance.md) | Platform lead, CISO, security lead |
| [03 — Day-1: hub deployment](docs/03-day1-hub.md) | Platform engineer (first deployment) |
| [04 — Day-2: spoke deployment](docs/04-day2-spokes.md) | Platform engineer (new spoke) |
| [05 — Operations and lifecycle](docs/05-operations.md) | SRE, operations |

## Template reference

This example uses the [`deployments/mono-vrack-lan-transit/`](../../deployments/mono-vrack-lan-transit/) template unchanged. Only the `terraform.tfvars` files change. To understand the underlying mechanisms, read the template documentation:

- [Architecture](../../deployments/mono-vrack-lan-transit/docs/01-architecture.md)
- [Day-1 landing zone](../../deployments/mono-vrack-lan-transit/docs/02-day1-landing-zone.md)
- [Day-2 spoke](../../deployments/mono-vrack-lan-transit/docs/03-day2-spoke.md)
- [Lifecycle and operations](../../deployments/mono-vrack-lan-transit/docs/04-lifecycle-and-operations.md)
