# Managed services in a zero‑trust spoke

Managed services (Kubernetes, databases, object storage, load balancers) have their **own control plane
and their own network attachments**: they do not inherit the spoke's security groups or the hub policy.
This page says, per service, what works inside a spoke, what to configure, and where the team's
autonomy stops. Everything here was verified on the sandbox (GRA9 and EU‑WEST‑PAR, August 2026); nothing
below lives in the templates — managed services are created by the platform team or by the team through
IAM, with the settings described here.

| Service | Inside the spoke? | What to configure | What the `team` identity can do |
|---|---|---|---|
| **MKS Standard, 3‑AZ region** | data plane yes: one private port, no public address, egress through the hub | a slot other than 2/3, a nodes LAN, three hub allowances, API‑server IP restrictions, OIDC | use the cluster; cannot change networking |
| **MKS Free** | partly: each node keeps a public management port | OVHcloud's mandatory port list on the project `default` group, hub egress TCP 80/443 for the node LAN | use the cluster; can publish a NodePort on the node's public address |
| **Managed Database** (private network) | yes | one `extra_egress` rule to the endpoint; logs to LDP via Service Logs | reach it; create it only with IAM `database/*` |
| **Object Storage S3** | n/a (public API) | an S3 credential and a bucket‑prefix policy per spoke | list containers only, until given a credential |
| **`Service` of type `LoadBalancer`** | private only | nothing — no Floating IP can be bound from a spoke | publish through the hub or a dedicated public spoke |

## Managed Kubernetes

### Choosing the plan

**Standard in a 3‑AZ region (`EU-WEST-PAR`, `EU-SOUTH-MIL`).** A node has one port on the nodes LAN — no
security group, port security off, `EXTERNAL-IP <none>`. Its default route is the Neutron subnet gateway,
i.e. the spoke router, hence the hub; `privateNetworkConfiguration.defaultVrackGateway` is refused in
3‑AZ regions and is not needed. Kubelet, image pulls and the control‑plane tunnel all cross the hub, so the
**data plane is inside the bubble**. The **API server remains a public OVHcloud endpoint**
(`https://<id>.c1.<region>.k8s.ovh.net`): a kubeconfig works from anywhere. Restrict it (below) rather
than pretend otherwise; private exposure is on the roadmap
([#542](https://github.com/ovh/public-cloud-roadmap/issues/542)).

**Free (and Standard in mono‑AZ regions).** A node has two ports: one on `Ext-Net` (public address,
"for management and control‑plane communication", project `default` security group) and one on the
spoke LAN. OVHcloud's mandatory rules on `default` accept **SSH and the NodePort range from the Internet**
and allow HTTPS egress on the public port — a team can publish a `NodePort` on the node's public address.
Fine for labs, say so; prefer Standard 3‑AZ for anything isolated.

### Address plan: slots 2 and 3 belong to the cluster

Clusters created without `ipAllocationPolicy` use `10.3.0.0/16` for Services (both plans), `10.2.0.0/16`
for pods on Free and `10.240.0.0/13` on Standard. In the `10.k.0.0/16` slot plan, **slots 2 and 3 are the
cluster's own ranges** (the `kubernetes` ClusterIP `10.3.0.1`, bound locally on every node by the
API‑server proxy, is the gateway of slot 3). `spoke-slot` refuses those slots unless
`allow_kube_default_cidr_overlap = true`; `10.240.0.0/13` lies beyond slot 200. Custom cluster CIDRs
(`podsIpv4Cidr`, `servicesIpv4Cidr`, ≥ /16 each) exist for the Standard plan only. The full list of
OVHcloud‑reserved ranges is in [01 — Architecture](01-architecture.md#address-ranges-ovhcloud-reserves-checked-2026-08-28).

### Standard 3‑AZ — what the hub must allow for the nodes LAN

| Proto | Port(s) | Destination | Usage |
|---|---|---|---|
| TCP | 443 | any (control plane `46.105.72.73`, `46.105.50.46`; snap store; registries) | kubelet, node management, bootstrap, image pulls |
| TCP | 25000–31999 | `46.105.72.73/32`, `46.105.50.46/32` | TLS tunnel node ↔ control plane |
| UDP | 123 | any, or the hub NTP | time |
| UDP | 53 | hub VIP (the nodes also try `213.186.33.99` and `1.1.1.1` — deny and ignore) | DNS |

No port 80, 8090 or 4443 is used by a Standard node. Give the nodes their **own LAN** so ordinary
instances of the spoke keep proxy‑only egress; log the allowance.

### Standard 3‑AZ — recipe

1. Spoke: `networks = { app = 0, nodes = 1 }`, a slot other than 2 or 3.
2. Hub: the allowances above for the nodes LAN only, logged; keep the block‑all for the rest.
3. Cluster: `plan: standard`, `privateNetworkId` / `nodesSubnetId` of the nodes LAN, **no**
   `privateNetworkConfiguration`; node pools carry `availabilityZones`.
4. **API server access**: set the *Authorised clients* list (`ipRestrictions`) to the hub's public address
   (teams run `kubectl` from their spoke, through the proxy) plus the administrators' addresses — an empty
   list means no restriction; bind the cluster to the company identity provider
   (`openIdConnect`) and manage access through groups and RBAC rather than the admin kubeconfig.
5. Observability: subscribe the cluster's audit logs to the spoke's stream (Service Logs) and ship
   container logs through the proxy — see [07 — Observability](07-observability.md).
6. `tools/audit-exposure.sh` with the OVHcloud service‑account variables reports clusters whose
   `ipRestrictions` is empty or which have no private network; it stays clean on this design (no Ext‑Net
   port, no Floating IP).

### Free — mandatory `default` group (OVHcloud table, verified)

| Direction | Proto | Port(s) | Remote | Usage |
|---|---|---|---|---|
| ingress | TCP | 22 | 0.0.0.0/0 | node management by OVHcloud |
| ingress | TCP | 30000–32767 | 0.0.0.0/0 | NodePort / LoadBalancer |
| egress | TCP | 443 | 0.0.0.0/0 | kubelet → API server |
| egress | TCP | 80 | 169.254.169.254/32 | metadata |
| egress | TCP | 25000–31999 | 0.0.0.0/0 | TLS tunnel pods ↔ API server |
| egress | TCP | 8090 | 0.0.0.0/0 | OVHcloud node management |
| egress | TCP | 4443 | 0.0.0.0/0 | metrics server |
| egress | UDP | 123 | 0.0.0.0/0 | NTP |
| egress | TCP+UDP | 53 | 0.0.0.0/0 | DNS |
| both | UDP | 8472, 4789 | node subnet | flannel / VXLAN between workers |
| both | TCP | 10250 | node subnet | API server → kubelet |

(`111/TCP` only with an NFS client.) With `strip_default_secgroup = true` these rules are gone and nodes
never leave `INSTALLING`: for a spoke that hosts a Free cluster, put the table back on `default` and allow
`TCP 80/443` from the node LAN at the hub (bootstrap uses Canonical mirrors on port 80, image pulls use
443). Nodes also try their Ext‑Net resolver (`213.186.33.99`) through the hub — deny and ignore, the
private subnet hands out the hub DNS.

### `Service` of type `LoadBalancer`

The cloud controller creates an Octavia load balancer with a VIP on the nodes subnet; the spoke router has
no external gateway, so no Floating IP can be bound and the `Service` stays `<pending>`
(`error creating LB floatingip`). Publishing goes through the hub or a dedicated public spoke. Deleting the
`Service` does not always remove the load balancer: check with `GET
/cloud/project/{id}/region/{region}/loadbalancing/loadbalancer` and delete leftovers.

## Managed Databases

Create the service with `network: private` on a spoke LAN (regions are named `GRA`, `DE`, `EU-WEST-PAR`… —
not `GRA9`). The service gets a private endpoint on that LAN, resolvable through the hub DNS; a spoke
instance reaches it with one `extra_egress` rule (TCP, the engine's port, `/32`). Nothing to open on the
hub — the database's control plane has its own path. Creation is an OVHcloud API call (IAM type
`database`): grant `publicCloudProject:apiovh:database/*` on the spoke project when the team must manage
its databases, and keep `networkType: private`; the audit reports public databases. Logs go to Logs Data
Platform through Service Logs ([07](07-observability.md)).

## Object Storage S3

The compute‑only `team` user can list containers but has no S3 credential and cannot create one
(`ovh_cloud_project_user_s3_credential` is an OVHcloud API call). Pattern for a spoke that needs S3:

- a dedicated OpenStack user `<spoke>-s3` created by the landing zone, with an S3 credential and an
  `ovh_cloud_project_user_s3_policy` limited to `arn:aws:s3:::<spoke>-*` — the team receives the access
  key, not the user;
- if the team must create buckets itself: IAM `publicCloudProject:apiovh:region/storage/*` on the spoke
  project for the team's identity;
- user creation stays with the `iac` identity (no IAM action creates *only* S3 users).

## Not tested

Standard in a mono‑AZ region (nodes are expected to keep a public port, as Free does), NodePort exposure
from the Internet on Free nodes, Private Registry, Managed Kafka/Redis, Object Storage through the proxy
(`HTTPS_PROXY` for the S3 endpoint).
