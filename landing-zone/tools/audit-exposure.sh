#!/usr/bin/env bash
# Exposure / drift audit of a spoke project, meant for a read-only OpenStack user (infrastructure_supervisor).
# Usage: source <openrc-audit>; tools/audit-exposure.sh [allowed-sg-regex]
# Reports: instances with a public (Ext-Net) address, floating IPs, ports without port security, MKS API-server IP restrictions / DB network type / public LBs (with OVH API credentials),
#          security groups outside the landing-zone set, and rules left in the 'default' group.
set -u
ALLOWED=${1:-'^(default|.*-base|.*-intra|.*-to-.*)$'}
P=${OS_PROJECT_ID:-?}
echo "== exposure audit — project $P — $(date -u +%FT%TZ)"
echo "-- instances with a public address (Ext-Net attached)"
openstack server list --long -f json | python3 -c "
import json,sys
n=0
for s in json.load(sys.stdin):
    nets=s.get('Networks') or {}
    pub=nets.get('Ext-Net') or nets.get('Ext-Net-Baremetal')
    if pub: n+=1; print(f'   VIOLATION  {s[\"Name\"]:24s} {pub}')
print(f'   {n} instance(s) on Ext-Net')"
echo "-- floating IPs"
openstack floating ip list -f value -c "Floating IP Address" -c "Fixed IP Address" -c Port | sed 's/^/   VIOLATION  /' ; echo "   $(openstack floating ip list -f value -c ID | wc -l) floating IP(s)"
echo "-- ports without port security (security groups bypassed)"
openstack port list --long -f json | python3 -c "
import json,sys
n=0
for p in json.load(sys.stdin):
    if p.get('Port Security Enabled') is False and p.get('Device Owner','').startswith('compute:'):
        n+=1; print(f'   VIOLATION  port {p[\"ID\"]} {p.get(\"Fixed IP Addresses\")}')
print(f'   {n} compute port(s) without port security')"
echo "-- security groups outside the landing-zone set ($ALLOWED)"
openstack security group list -f value -c Name | python3 -c "
import re,sys
pat=re.compile(sys.argv[1]); n=0
for name in sys.stdin.read().split():
    if not pat.match(name): n+=1; print(f'   DRIFT      security group {name}')
print(f'   {n} unexpected group(s)')" "$ALLOWED"
echo "-- 'default' security group rules (expected 0)"
n=$(openstack security group rule list default -f value -c ID | wc -l); [ "$n" -eq 0 ] && echo "   OK         0 rule(s)" || echo "   VIOLATION  $n rule(s) in default"

# ---- managed services (OVHcloud API) — optional: needs OVH_CLIENT_ID / OVH_CLIENT_SECRET (service account) and OVH_PROJECT_ID
if [ -n "${OVH_CLIENT_ID:-}" ] && [ -n "${OVH_CLIENT_SECRET:-}" ] && [ -n "${OVH_PROJECT_ID:-}" ]; then
  TOKEN=$(curl -s --max-time 30 -X POST https://www.ovh.com/auth/oauth2/token -d grant_type=client_credentials -d "client_id=$OVH_CLIENT_ID" -d "client_secret=$OVH_CLIENT_SECRET" -d scope=all | python3 -c 'import json,sys; print(json.load(sys.stdin).get("access_token",""))')
  ovh(){ curl -s --max-time 30 -H "Authorization: Bearer $TOKEN" -H "Accept: application/json" "https://${OVH_ENDPOINT_HOST:-eu.api.ovh.com}/1.0/cloud/project/$OVH_PROJECT_ID$1"; }
  echo "-- Managed Kubernetes: API server restricted by IP, private network, plan"
  for k in $(ovh /kube | python3 -c 'import json,sys; print(" ".join(json.load(sys.stdin)))'); do
    ovh /kube/$k > /tmp/.audit_kube.$$; ovh /kube/$k/ipRestrictions > /tmp/.audit_ipr.$$
    python3 - "$k" /tmp/.audit_kube.$$ /tmp/.audit_ipr.$$ <<'PY'
import json,sys
k,kf,rf=sys.argv[1:]; c=json.load(open(kf)); r=json.load(open(rf))
name=c.get('name',k); plan=c.get('plan'); pn=c.get('privateNetworkId')
print(f"   {'VIOLATION' if not r else 'OK       '}  {name:24s} apiserver allowed clients: {r if r else 'ANY (empty list)'}")
print(f"   {'VIOLATION' if not pn else 'OK       '}  {name:24s} private network: {pn or 'none'}  plan: {plan}")
if plan=='free': print(f"   NOTE       {name:24s} Free plan: nodes keep a public management port (SSH + NodePort range open by OVHcloud rule)")
PY
    rm -f /tmp/.audit_kube.$$ /tmp/.audit_ipr.$$
  done
  echo "-- Managed Databases: network type"
  for d in $(ovh /database/service | python3 -c 'import json,sys; print(" ".join(json.load(sys.stdin)))'); do
    ovh /database/service/$d | python3 -c 'import json,sys; s=json.load(sys.stdin); nt=s.get("networkType"); print(f"   {"VIOLATION" if nt=="public" else "OK       "}  {s.get("description") or s["id"]:24s} {s.get("engine")} network: {nt}")'
  done
  echo "-- Load Balancers with a public address"
  for reg in $(ovh /region | python3 -c 'import json,sys; print(" ".join(json.load(sys.stdin)))'); do
    ovh /region/$reg/loadbalancing/loadbalancer 2>/dev/null | python3 -c 'import json,sys
try: lbs=json.load(sys.stdin)
except Exception: lbs=[]
for lb in lbs if isinstance(lbs,list) else []:
    fip=lb.get("floatingIp"); print(f"   {"VIOLATION" if fip else "OK       "}  {lb.get("name","")[:24]:24s} vip {lb.get("vipAddress")} floating: {fip or "none"}")'
  done
else
  echo "-- managed services: skipped (set OVH_CLIENT_ID / OVH_CLIENT_SECRET / OVH_PROJECT_ID to audit MKS API-server restrictions, database network type, public LBs)"
fi
