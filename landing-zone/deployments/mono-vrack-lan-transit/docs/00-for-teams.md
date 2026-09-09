# For teams — your spoke in one page

You were handed a **spoke**: an isolated OVHcloud Public Cloud project connected to the company network hub. Security is already done. Here is everything you need.

## What you get

- A project with a **private network** (e.g. `10.7.0.0/24`), DHCP, DNS.
- An OpenStack identity (`openrc`) that can **create, start, stop, resize and delete instances, volumes and snapshots**, and pick among the security groups provided.
- Internet access **through the hub proxy**: `http://<hub-vip>:3128` (the address is in your `openrc` as `HTTP_PROXY`). DNS and NTP are served by the same address.
- Horizon (`https://horizon.cloud.ovh.net`) with the same identity.

## Your three gestures

```bash
source openrc-team.sh                                    # 1. authenticate
openstack server create --image "Debian 12" --flavor b3-8 \
  --network <spoke>-lan-app-net --security-group <spoke>-base --security-group <spoke>-intra \
  --key-name mykey web-01                                # 2. boot with the provided groups
export http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY    # 3. reach the Internet through the hub
```

Instances of the same spoke talk to each other with `<spoke>-intra`. Everything else is closed by default.

## What you cannot do — by design

| You try… | What happens |
|---|---|
| create a public / floating IP | refused (403) |
| create or edit a security group, a route, a network | refused (403) |
| attach `Ext-Net` to an instance | allowed, but **no traffic leaves**: your security groups have no public destination |
| boot without a security group | the instance has no connectivity at all |
| reach the Internet directly (no proxy) | dropped at your port, and again at the hub |

## How to ask for more

Every change is a pull request on your spoke's configuration, reviewed by the platform team and applied with OpenTofu:

| Need | Change |
|---|---|
| talk to another spoke | egress rule in your `-base` group + ingress rule in theirs + a hub rule |
| reach a public API directly (no proxy) | `extra_egress` entry (destination IP + port) — reviewed carefully |
| a second network (e.g. `db`) | one line in `networks` |
| more throughput than the hub proxy gives | a dedicated Gateway on your LAN, decided by the platform team |

## Your logs

Ship them through the proxy, like everything else: Fluent Bit or Vector with `HTTP_PROXY` set to the hub
address, GELF over TLS to your Logs Data Platform stream (the platform team hands you the stream token as a
secret). Managed services (databases, Kubernetes audit) are subscribed to the same stream without any agent.
Details in [07 — Observability](07-observability.md).

## When something does not work

- *"My instance cannot reach anything"* — you booted without a security group, or without `<spoke>-base`. Rebuild with the groups.
- *"apt / curl hang"* — set `http_proxy` / `https_proxy` (see above). Direct egress is blocked, on purpose.
- *"I cannot ping the other spoke"* — inter-spoke traffic needs rules on both sides; open a PR.
- Anything else: the platform team can read the hub firewall log, which records every denied flow with your source address.
