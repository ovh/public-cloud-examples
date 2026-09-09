#!/usr/bin/env bash
# Day-1 post-boot for the mono-vRack hub (hub_services = true): wait for the API, install the plugins listed in config on both nodes,
# apply the proxy destination allowlist, then (re)start the proxy. Idempotent — re-run it whenever PROXY_WHITELIST changes.
# Usage: hub-postboot.sh <fip> <secondary-hasync-ip> <ssh-key>
#   env API_AUTH=key:secret (required), PROXY_WHITELIST=<comma-separated squid url_regex list> (optional, empty = any destination)
#   PROXY_SSL_PORTS=<comma-separated port:label list> (optional, default 443:https), REMOTE_SYSLOG=<host:port> (optional, empty = local logs only)
set -u
FIP=$1; SEC_HA=$2; KEY=$3; AUTH=${API_AUTH:?API_AUTH=key:secret required}; WL=${PROXY_WHITELIST:-}; SP=${PROXY_SSL_PORTS:-443:https}; RS=${REMOTE_SYSLOG:-}
# allowlist mode = whitelist patterns + deny-all blacklist (the OPNsense template evaluates the whitelist first); squid needs a restart, not just a reconfigure, to apply ACL changes
WLJ=$(printf '%s' "$WL" | sed 's/\\/\\\\/g')   # JSON-escape the regex backslashes
if [ -n "$WL" ]; then ACL=$(printf '{"proxy":{"forward":{"acl":{"whiteList":"%s","blackList":"^.*$","sslPorts":"%s"}}}}' "$WLJ" "$SP"); else ACL=$(printf '{"proxy":{"forward":{"acl":{"whiteList":"","blackList":"","sslPorts":"%s"}}}}' "$SP"); fi
# remote syslog (TLS) for the node's own logs: one destination named below, created/updated/removed to match REMOTE_SYSLOG; OPNsense wants a client certificate for TLS → the node's Web GUI certificate
RS_DESCR="landing-zone remote syslog"
syslog_apply(){ # $1 = api function name (api | api_sec)
  local call=$1 q="'" ; [ "$call" = api ] && q=""
  local cur cert body
  cur=$($call syslog/settings/searchDestinations -X POST -H "${q}Content-Type: application/json${q}" -d "${q}{\"current\":1,\"rowCount\":50}${q}" | python3 -c "import json,sys; print(next((r['uuid'] for r in json.load(sys.stdin).get('rows',[]) if r.get('description')=='$RS_DESCR'),''))" 2>/dev/null)
  if [ -z "$RS" ]; then
    [ -n "$cur" ] && echo "$1 remote syslog removed: $($call syslog/settings/delDestination/$cur -X POST -d "${q}{}${q}")"
  else
    cert=$($call trust/cert/search -X POST -H "${q}Content-Type: application/json${q}" -d "${q}{\"current\":1,\"rowCount\":20}${q}" | python3 -c "import json,sys; rows=json.load(sys.stdin).get('rows',[]); print(next((r['refid'] for r in rows if 'Web GUI' in r.get('descr','')), rows[0]['refid'] if rows else ''))" 2>/dev/null)
    body=$(printf '{"destination":{"enabled":"1","transport":"tls4","hostname":"%s","port":"%s","rfc5424":"1","program":"","level":"","facility":"","certificate":"%s","description":"%s"}}' "${RS%%:*}" "${RS##*:}" "$cert" "$RS_DESCR")
    if [ -n "$cur" ]; then echo "$1 remote syslog updated: $($call syslog/settings/setDestination/$cur -X POST -H "${q}Content-Type: application/json${q}" -d "${q}$body${q}")"
    else echo "$1 remote syslog added: $($call syslog/settings/addDestination -X POST -H "${q}Content-Type: application/json${q}" -d "${q}$body${q}")"; fi
  fi
  echo "$1 syslog reconfigure: $($call syslog/service/reconfigure -X POST -d "${q}{}${q}")"
}
SSH="ssh -i $KEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o BatchMode=yes -o ConnectTimeout=20"
api(){ curl -sk --max-time 60 -u "$AUTH" "https://$FIP:8443/api/$1" "${@:2}"; }
api_sec(){ $SSH admin@$FIP "curl -sk --max-time 60 -u '$AUTH' 'https://$SEC_HA:8443/api/$1' ${*:2}"; }
wait_api(){ # $1 = "primary" | "secondary"
  for i in $(seq 1 90); do
    if [ "$1" = primary ]; then code=$(curl -sk -o /dev/null -w '%{http_code}' --max-time 8 -u "$AUTH" "https://$FIP:8443/api/core/firmware/status")
    else code=$($SSH admin@$FIP "curl -sk -o /dev/null -w '%{http_code}' --max-time 8 -u '$AUTH' https://$SEC_HA:8443/api/core/firmware/status" 2>/dev/null); fi
    [ "$code" = "200" ] && { echo "$1 API up after $((i*10))s"; return 0; }; sleep 10
  done; echo "$1 API not reachable"; return 1
}
wait_upgrade(){ for i in $(seq 1 60); do st=$( [ "$1" = primary ] && api core/firmware/upgradestatus || api_sec core/firmware/upgradestatus ); echo "$st" | grep -q '"status":"done"' && return 0; sleep 10; done; echo "$1: upgrade still running"; }
wait_api primary || exit 1
echo "primary syncPlugins: $(api core/firmware/syncPlugins -X POST -d '{}')"; wait_upgrade primary
# the pre-seeded proxy model is minimal: a settings/set normalises it (defaults applied) before the first render
echo "primary proxy normalise: $(api proxy/settings/set -X POST -H 'Content-Type: application/json' -d '{}')"
echo "primary proxy allowlist: $(api proxy/settings/set -X POST -H 'Content-Type: application/json' -d "$ACL")"
echo "primary proxy reconfigure: $(api proxy/service/reconfigure -X POST -d '{}') restart: $(api proxy/service/restart -X POST -d '{}')"
syslog_apply api
wait_api secondary || exit 1
echo "secondary syncPlugins: $(api_sec core/firmware/syncPlugins -X POST -d "'{}'")"; wait_upgrade secondary
echo "secondary proxy normalise: $(api_sec proxy/settings/set -X POST -H "'Content-Type: application/json'" -d "'{}'")"
echo "secondary proxy allowlist: $(api_sec proxy/settings/set -X POST -H "'Content-Type: application/json'" -d "'$ACL'")"
echo "secondary proxy reconfigure: $(api_sec proxy/service/reconfigure -X POST -d "'{}'") restart: $(api_sec proxy/service/restart -X POST -d "'{}'")"
syslog_apply api_sec
# the plugin install is asynchronous: do not report success until squid answers on both nodes
proxy_wait(){ for i in $(seq 1 18); do st=$( [ "$1" = primary ] && api proxy/service/status || api_sec proxy/service/status ); echo "$st" | grep -q '"status":"running"' && { echo "$1 proxy running after $(( (i-1)*10 ))s"; return 0; }; sleep 10; [ $((i % 6)) -eq 0 ] && { [ "$1" = primary ] && api core/firmware/syncPlugins -X POST -d '{}' >/dev/null && api proxy/service/restart -X POST -d '{}' >/dev/null || api_sec core/firmware/syncPlugins -X POST -d "'{}'" >/dev/null; }; done; echo "$1 proxy NOT running after 3 min"; return 1; }
proxy_wait primary; proxy_wait secondary
echo "proxy status: primary=$(api proxy/service/status | grep -o '"status":"[a-z]*"') secondary=$(api_sec proxy/service/status | grep -o '"status":"[a-z]*"')"
