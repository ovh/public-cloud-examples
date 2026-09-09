#!/usr/bin/env bash
# A freshly activated compute region exposes its Keystone endpoints service by service, with a lag
# behind the control-plane status. This waits until compute, image and network are all present for
# the region, with the project user that the stack just created.
# Usage: wait-openstack-catalog.sh <region>   (env: OS_USERNAME, OS_PASSWORD, OS_TENANT_ID)
set -u
REGION=$1
BODY=$(printf '{"auth":{"identity":{"methods":["password"],"password":{"user":{"name":"%s","domain":{"name":"Default"},"password":"%s"}}},"scope":{"project":{"id":"%s"}}}}' "$OS_USERNAME" "$OS_PASSWORD" "$OS_TENANT_ID")
# The auth VIP fronts several Keystone backends whose caches converge at different times right
# after a region activation: require several consecutive good answers before declaring readiness.
STREAK=0
for i in $(seq 1 120); do
  ok=$(curl -s --max-time 20 -H 'Content-Type: application/json' -d "$BODY" https://auth.cloud.ovh.net/v3/auth/tokens | python3 -c "
import json,sys
try: cat=json.load(sys.stdin)['token']['catalog']
except Exception: print(0); raise SystemExit
have={s['type'] for s in cat for e in s.get('endpoints',[]) if e.get('region')=='$REGION' and e.get('interface')=='public'}
print(1 if {'compute','image','network'} <= have else 0)")
  if [ "$ok" = "1" ]; then STREAK=$((STREAK+1)); else STREAK=0; fi
  [ "$STREAK" -ge 5 ] && { echo "catalog ready for $REGION after $(( (i-1)*10 ))s (5 consecutive probes)"; exit 0; }
  sleep 10
done
echo "catalog for $REGION not ready after 20 minutes" >&2; exit 1
