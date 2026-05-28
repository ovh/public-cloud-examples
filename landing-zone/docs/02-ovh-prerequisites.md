# OVHcloud prerequisites

## Account and permissions

- An **OVHcloud account** with access to the **API** and **Public Cloud**.
- Enough rights to create **Public Cloud projects**, **OpenStack users**, **vRacks** and to attach projects to a vRack.

## Creating API credentials (Application Key, Secret, Consumer Key)

The deployments use the **OVH provider** with three values:

| Variable (typical) | Role |
|--------------------|------|
| `application_key` | API application identifier |
| `application_secret` | Associated secret |
| `consumer_key` | Token carrying the **permissions** granted to the application |

### Steps (summary)

1. Log in to the [OVHcloud manager](https://www.ovh.com/manager/).
2. Go to the **API** section (application / key creation) — the exact procedure evolves with the UI; refer to the **[official "Getting started with OVHcloud APIs" documentation](https://help.ovhcloud.com/csm/fr-api-getting-started-ovhcloud-api?id=kb_article_view&sysparm_article=KB0042789)**.
3. Generate an **Application Key** and an **Application Secret**.
4. Generate a **Consumer Key** by selecting the minimum required **permissions** (creating projects, vRacks, cloud users, etc.). When in doubt, a first token with a broad scope can be used in the lab, then tightened in production (least-privilege principle).
5. Note the `endpoint`: in Europe, **`ovh-eu`** is commonly used in this repository's examples.

**Never** commit these secrets. Use **`TF_VAR_*` environment variables** to inject them — see [05 — Security and secrets](05-security-and-secrets.md). The `terraform.tfvars` files are reserved for non-sensitive network configuration.

## Public Cloud

- Create or identify at least one **project** for tests; depending on the architecture, Day‑1 may create additional projects (hub and/or QA spoke) via the code.
- Pick an OpenStack **region** (e.g. `EU-WEST-PAR`, `GRA11`, `SBG7`) consistent with your **localisation** constraints and flavor availability.

## vRack

- A **vRack** is a private network that spans every OVHcloud location.
- After attachment, a short delay may be required before creating VLAN networks (the code includes `time_sleep` pauses to mitigate transient OVH errors).

## OpenTofu

- Install [OpenTofu](https://opentofu.org/) **≥ 1.11.4** — **required**. HashiCorp Terraform is not compatible: state encryption (`encryption {}`) is an OpenTofu-specific feature.
- Run `tofu init` in each deployment directory before `plan` / `apply`.

## What comes next

- First deployment: pick your architecture in the [documentation index](README.md).
