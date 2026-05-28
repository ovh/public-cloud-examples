# Lifecycle and operations

## Add a spoke

1. Duplicate `deployments/multi-vrack-ipsec/spoke-template` (or clone the state/workspace).
2. New backend / isolated state.
3. Unique variables: `ipsec_reqid`, VLAN, CIDR, `vti_link_cidr`, project/vRack names.
4. `tofu apply`.

## Remove a spoke

1. `tofu destroy` in the directory of the affected spoke.
2. Check on the **hub OPNsense** that the IPsec objects (PSK, connection, auth, child, VTI), the **VTI gateway** and the **route** to the spoke LAN have indeed been removed. With `destroy_method = "POST"` on the `restapi` provider, deletion via API should be effective; when in doubt, verify manually in the UI.

## IPsec tunnel after reboot / first boot

It is common to need to **restart the IPsec connection** (or wait for convergence) after the spoke instances are created: both endpoints must be ready and the configuration applied (reconfigure on the hub is triggered by the deployment).

## API / restapi troubleshooting

- The **Mastercard/restapi** provider can display *internal validation failed; object ID is not set* when the OPNsense API returns `result: failed` **without** a `uuid` — the real cause is often a **business validation** (invalid field, duplicate, wrong JSON case).
- Temporarily enable `debug = true` on the `restapi` provider and `TF_LOG=TRACE` to see the HTTP response body.
- Avoid sending the `Content-Type: application/json` header on **all** requests if the provider applies it to empty GETs: it caused **400 Invalid JSON** errors on OPNsense in some cases (the current repository configuration does not enforce that global header).

## State and secrets

- The **state** can contain API keys and passwords in resources; protect the backend.
- `tofu output -raw` for sensitive outputs only on a trusted workstation.

## Transient OVH resources

Errors such as **VLAN already reserved** on vRack can occur when the OVH APIs are not yet synchronised; running `apply` again a few seconds later or relying on the repository's `time_sleep` blocks mitigates the issue.

## Links

- Day‑1: [Landing zone](02-day1-landing-zone.md).
- Day‑2: [Spoke](03-day2-spoke.md).
