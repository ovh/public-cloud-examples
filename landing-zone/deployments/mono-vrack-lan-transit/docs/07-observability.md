# Observability — logs out of the bubbles, into Logs Data Platform

Logs Data Platform (LDP) is reachable only through public endpoints (`gra1`, `gra2`, `gra3`,
`gra159.logs.ovh.com`…; no vRack or private endpoint). From a zero‑trust spoke that means *leaving* — and
the landing zone already has exactly three ways out. None of them adds a flow to the spoke contract.

| Source | Path to LDP | Crosses the spoke? | What to set |
|---|---|---|---|
| **Hub OPNsense** — firewall pass/block (every attempt made by every spoke), DHCP, DNS, proxy | syslog RFC 5424 over TLS from the hub WAN to an LDP **dedicated input** (Logstash/Flowgger, token set by LDP, hub address allow‑listed) | no — it is the hub | `hub_remote_syslog = { host, port = 6514 }` |
| **MKS audit logs, Managed Databases, Load Balancers, account / IAM / KMS** | **Service Logs**: a subscription from the service to a stream, agentless | no — OVHcloud backend | the subscription, at creation |
| **Pods** (Fluent Bit DaemonSet) and **instances** (Fluent Bit / Vector) | GELF TLS `12202` (or syslog TLS `6514`) through the hub proxy: `HTTP_PROXY=http://<hub-vip>:3128` — Fluent Bit and Vector tunnel any output through an HTTP proxy | yes, through the proxy | `logs.ovh.com` in `proxy_allowed_domains`, `[443, 6514, 12202]` in `proxy_connect_ports` |
| **Metrics** (Prometheus remote write) | HTTPS through the proxy to a Metrics tenant | yes, through the proxy | later — see the roadmap note |

Not a path: an `extra_egress` rule towards LDP addresses. It bypasses the proxy, the addresses are resolved
rather than guaranteed, and it is one exception per spoke to maintain — exactly the public destination the
contract excludes. A relay at the hub (Vector receiving syslog from the spokes) is only worth adding for
shippers that cannot speak to an HTTP proxy (`rsyslog`, `syslog-ng`).

## LDP in five facts

- **Streams are the unit of everything**: write token (`X-OVH-TOKEN`), indexed retention (14 days, 1 month,
  3 months, 1 year), a GB limit after which the stream stops ingesting (a cost ceiling), cold archives
  (1, 2, 5, 10 years), access rights.
- **Mutualized inputs** listen on fixed TLS ports: syslog `6514`, GELF `12202`, LTSV `12201`/`12200`,
  Cap'n Proto `12204`, Beats `5044`; the OpenSearch API answers on `9200`. **Dedicated inputs** add a port
  of your choice, source‑address allow‑listing and a token set server‑side — the right input for OPNsense.
- **IAM is native**: resource `urn:v1:eu:resource:ldp:<service>`, actions `ldp:apiovh:*`, streams as
  sub‑resources through resource groups. The legacy role model is being retired
  ([#178](https://github.com/ovh/management-security-operations-roadmap/issues/178)) — start in IAM.
- **Service Logs** (agentless) covers, on Public Cloud, Managed Kubernetes audit logs, Load Balancer and
  Managed Databases, plus account Activity/Audit/IAM, KMS and OVHcloud Connect; subscriptions are created
  from the Manager or the API towards a stream of the same OVHcloud account.
- **An LDP service belongs to the OVHcloud account, not to a Public Cloud project** — this is the one
  place where the "one spoke = one project = one bill" symmetry breaks; see *Tenancy* below.

## Tenancy and billing

Two models work, and combine:

| Model | How | Fits |
|---|---|---|
| **One LDP service per spoke** | the spoke's `iac` identity creates it; the IAM policy is on the service; one console per team | teams that want their own invoice line and their own console |
| **One platform service, one stream per spoke** (recommended default) | streams `hub`, `account`, then one per spoke; an IAM policy per stream through a resource group; a GB limit per stream; usage per stream (`ldp:apiovh:metrics/get`) for re‑billing | one console for the platform (hub, account, Service Logs) and the spokes; a single invoice |

In both models the **stream token is a spoke secret** (a Kubernetes `Secret`, an instance metadata set by
`iac`), the hub and the audit write to streams the teams can read but not write, and retention is decided
per stream.

## Keep LDP outside the landing‑zone state

The landing zone must converge whether or not LDP exists: the hub inputs (`proxy_allowed_domains`,
`proxy_connect_ports`, `hub_remote_syslog`) are OPNsense settings applied by the post‑boot step, with no
OVHcloud provider resource behind them. LDP objects (service, streams, tokens, dedicated inputs,
Service Logs subscriptions) live in their own optional state or are created by an idempotent API script;
the landing zone consumes *values* (an input hostname, a token) through variables, never *resources*. The
provider offers `ovh_dbaas_logs_cluster`, `ovh_dbaas_logs_input`, `ovh_dbaas_logs_output_graylog_stream`,
`ovh_dbaas_logs_token`, `ovh_dbaas_logs_role*`, and the subscriptions
`ovh_cloud_project_kube_log_subscription`, `ovh_cloud_project_database_log_subscription`,
`ovh_cloud_project_region_loadbalancer_log_subscription` — use them in the satellite state if they suit you.

## Recipe

1. **LDP**: one service (IAM), streams `hub`, `account`, one per spoke with a GB limit; a dedicated input
   (syslog RFC 5424, TLS) allow‑listing the hub's public address.
2. **Landing zone** (`terraform.tfvars`, then `tofu apply` — the post‑boot step re‑runs, no instance is
   rebuilt):
   ```hcl
   proxy_allowed_domains = ["ubuntu.com", "docker.io", "logs.ovh.com"]
   proxy_connect_ports   = [443, 6514, 12202]
   hub_remote_syslog     = { host = "<dedicated-input>.logs.ovh.com", port = 6514 }
   ```
   The hub's own logs (pass/block, DHCP, unbound, squid) then reach the `hub` stream from both nodes.
3. **Managed services**: subscribe audit logs (MKS), service logs (databases, load balancers) to the spoke's
   stream when the service is created — Manager, API, or the provider resources above.
4. **Pods** — Fluent Bit DaemonSet, GELF output, token in a `Secret`, proxy through the hub:
   ```yaml
   env:
     - { name: HTTP_PROXY,  value: "http://192.168.10.99:3128" }
     - { name: HTTPS_PROXY, value: "http://192.168.10.99:3128" }
     - { name: NO_PROXY,    value: "10.0.0.0/8,192.168.10.0/24,169.254.169.254" }
     - { name: FLUENT_LDP_TOKEN, valueFrom: { secretKeyRef: { name: ldp-token, key: ldp-token } } }
   ```
   with the filters of OVHcloud's Fluent Bit guide (`Record X-OVH-TOKEN ${FLUENT_LDP_TOKEN}`, `host` from
   the pod name) and `[OUTPUT] Name gelf  Host <cluster>.logs.ovh.com  Port 12202  Mode tls  tls On`.
5. **Instances**: Fluent Bit or Vector with the same proxy variables (the spoke `openrc` already exports
   `HTTP_PROXY`); no syslog daemon pointed directly at LDP.
6. **Audit**: `tools/audit-exposure.sh` lists the managed services of the spoke; check that each has its
   subscription and that the spoke's stream exists.

## Metrics and the Observability roadmap

OVHcloud's **Metrics** service (Prometheus remote write, PromQL, alerting — "free with instances") has
tenants in Gravelines and Strasbourg in alpha/beta; Paris and Milan 3‑AZ tenants are open items
([#132](https://github.com/ovh/management-security-operations-roadmap/issues/132),
[#133](https://github.com/ovh/management-security-operations-roadmap/issues/133)), as are per‑service
metrics (load balancers, gateways, volumes, instances, databases, object storage). Service Logs keeps
extending (OpenStack API logs, gateway and load‑balancer events, backups) and LDP moves to OpenSearch 3.0
and IAM‑only access. None of it replaces the primitives above — streams, tokens, subscriptions, the proxy
path. When Metrics reaches your region: one more tenant, `metrics.ovh.net` in the allowlist, the same
proxy.
