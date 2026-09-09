# OPNsense HA — Existing project

Deploys a **highly available OPNsense** firewall pair into an existing OVHcloud Public Cloud project. No project or vRack creation needed — you bring your own.

> **OPNsense image:** this deployment uses an unofficial cloud-ready image (OPNsense **26.7** by default, see `opnsense_version`). Read [04 — OPNsense Cloud-Ready image](../../docs/04-image-opnsense-cloud-ready.md) before deploying.
>
> **Configuration format:** the injected `config.xml` is written for the OPNsense 26.7 model — firewall rules and Source NAT in the MVC sections (`OPNsense/Firewall/Filter`), HA settings in the root `hasync` node. No legacy rule page or `os-firewall-legacy` plugin is needed.
>
> **Secrets:** passwords, API keys and state passphrase must not appear in `terraform.tfvars`. Read [05 — Security and secrets](../../docs/05-security-and-secrets.md).

## Architecture

```
                          Internet
                              │
                    ┌─────────▼─────────┐
                    │  OVH Managed GW   │  (provisioned on the WAN subnet)
                    └─────────┬─────────┘
                              │  WAN VLAN (default: 100)
                 ┌────────────┴────────────┐
                 │                         │
        ┌────────▼────────┐       ┌────────▼────────┐
        │  OPNsense       │       │  OPNsense       │
        │  Primary (CARP  │◄─────►│  Secondary      │
        │  MASTER)        │ pfsync│  (CARP BACKUP)  │
        │  AZ-a (3AZ)     │ xmlrpc│   AZ-b (3AZ)    │
        └────────┬────────┘       └────────┬────────┘
                 │                         │
                 └────────────┬────────────┘
                              │  LAN VLAN (default: 200)
                    ┌─────────▼─────────┐
                    │  Your workloads   │
                    │  GW: LAN CARP VIP │
                    └───────────────────┘

  Floating IP ──► WAN CARP VIP (automatically follows the active node)
  HA Sync     ──► dedicated /30 VLAN 199 (pfsync state + xmlrpc config)
```

**HA mechanism:**
- **CARP** (unicast, `peer` addresses) provides virtual IPs on the WAN and LAN — the Floating IP is bound to the detached WAN VIP port and follows the CARP master
- **pfsync** synchronises the firewall state over the HASYNC interface (`opt1`), so existing connections survive failover
- **xmlrpc** replicates configuration changes (aliases, rules, NAT, users, certificates, VIPs, routes, tunables…) from the primary to the secondary — the synced sections are listed in `hasync/syncitems`
- **Anti-affinity** ensures the primary and secondary nodes run on separate hypervisors
- **Availability zones** (3-AZ regions only) further separate the nodes across distinct rooms

## Prerequisites

| Prerequisite | Details |
|--------------|---------|
| OVHcloud account | Public Cloud project with a **vRack already attached** |
| OpenStack user | User with the *administrator* role on the project — download its `openrc.sh` from the console (Users & Roles). No OVH API token is needed. |
| OpenTofu ≥ 1.11.4 | `brew install opentofu` or [opentofu.org/docs/intro/install](https://opentofu.org/docs/intro/install/) |

## Quick start

```bash
# 1. Enter the directory
cd deployments/opnsense-ha-existing-project

# 2. Prepare the network configuration (non-sensitive values only)
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars # nano or your favorite editor to edit variables depending on your landing zone

# 3. Authenticate against OpenStack and inject secrets (see docs/05-security-and-secrets.md)
source ~/openrc.sh                      # OS_AUTH_URL, OS_PROJECT_ID, OS_USERNAME, OS_PASSWORD…
export TF_VAR_tofu_state_passphrase="..."
export TF_VAR_admin_password="..."
export TF_VAR_ha_password="..."

# 4. Initialise the providers
tofu init

# 5. Review the deployment plan
tofu plan

# 6. Deploy (~5 minutes)
tofu apply
```

## Outputs

After `tofu apply`:

```
webgui_url    = "https://<floating-ip>:8443"   → OPNsense WebGUI
ssh_command   = "ssh admin@<floating-ip>"       → SSH access
floating_ip   = "<floating-ip>"                → Public IP (follows the active node)
lan_carp_ip   = "<ip>"                         → Default gateway for your workloads
wan_carp_ip   = "<ip>"                         → WAN virtual IP
az_placement  = { primary = "...", secondary = "..." }
```

Inspect the API credentials and the generated SSH key:
```bash
tofu output api_key
tofu output -raw api_secret          # sensitive — only on a trusted workstation
tofu output -raw ssh_private_key     # only when ssh_public_key_path was not set
```

## Firewall policy shipped by default

| Rule (Firewall › Rules) | Purpose |
|-------------------------|---------|
| WAN / LAN · TCP 8443 and 22 from `AdminClients` | Management access (`admin_client_ip` seeds the alias) |
| LAN · any from LAN net | Workloads egress through the cluster |
| HASYNC · pfsync and TCP 8443 between the two nodes | State and configuration synchronisation |
| WAN / LAN · CARP between the two nodes | Unicast CARP advertisements (the automatic *CARP defaults* rule only covers multicast) |

Source NAT runs in *hybrid* mode: the LAN is translated to the **WAN CARP VIP** (so outbound traffic always leaves through the Floating IP, whichever node is master), and the firewall's own traffic is excluded from NAT.

## Region reference

### 3-AZ regions — automatic dual-AZ placement

| Region | Available AZs |
|--------|---------------|
| `EU-WEST-PAR` | `eu-west-par-a`, `eu-west-par-b`, `eu-west-par-c` |
| `EU-SOUTH-MIL` | `eu-south-mil-a`, `eu-south-mil-b`, `eu-south-mil-c` |

On the first `tofu apply`, one of the three possible AZ pairs (a+b, a+c, b+c) is drawn at random and pinned in the state. It only changes if you change `region`. No further configuration required.

### Mono-AZ regions examples — hypervisor anti-affinity only

`GRA9` · `GRA11` · `SBG7` · `BHS5` · `WAW1` · `DE1` · `UK1`

Nodes are placed on separate hypervisors through an OpenStack anti-affinity server group.

## Network architecture

| Network | Default VLAN | Default CIDR | Role |
|---------|--------------|--------------|------|
| WAN | 100 | `10.1.0.0/24` | Link to the Neutron router (OVHcloud Gateway) / Internet |
| LAN | 200 | `192.168.10.0/24` | Workload network |
| HASYNC | 199 | `10.0.254.0/30` | Isolated pfsync + xmlrpc channel |

Address `.99` on the WAN and the LAN is the CARP virtual IP. The LAN subnet declares it as its gateway, so a DHCP client on the LAN receives the CARP VIP as default route (and the DNS host route through it) with no manual configuration.

## Keeping the secondary in sync

OPNsense replicates configuration **on demand**, not on every save: after changing things on the primary, push them from *System › High Availability › Status* ("Synchronize config to backup" / "Restart all services"), or through the API:

```bash
curl -sk -u "$API_KEY:$API_SECRET" -X POST -d '{}' https://<floating-ip>:8443/api/core/hasync_status/restart_all
```

The sections replicated are listed in `hasync/syncitems` (aliases, rules, NAT, users, certificates, VIPs, routes, tunables, …). Firewall *state* replication (pfsync) is continuous and needs no action.

## Flavors

| Flavor | vCPU | RAM | Use case |
|--------|------|-----|----------|
| `b3-16` (default) | 4 | 16 GB | General use, up to ~1 Gbps |
| `b3-64` | 16 | 64 GB | High throughput, large rule tables |

## Teardown

```bash
tofu destroy
```

Removes every resource created by this deployment (VMs, ports, subnets, networks, router, floating IP, keypair, image). Your project and your vRack are left untouched.
