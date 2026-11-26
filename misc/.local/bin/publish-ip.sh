#!/bin/sh
# posts the default-route IP to a secret gist when it changes; retries while the network comes up after boot
log() { printf '%s %s\n' "$(date '+%F %T')" "$*"; }
cache=$HOME/.cache/mini-ip
gist=$(cat "$HOME/.config/publish-ip.gist") || { log "missing ~/.config/publish-ip.gist"; exit 1; }
i=0
while [ $i -lt 12 ]; do
  if="$(route -n get default 2>/dev/null | awk '/interface:/{print $2}')"
  ip=$([ -n "$if" ] && ipconfig getifaddr "$if")
  [ -n "$ip" ] && break
  i=$((i+1)); sleep 10
done
[ -n "$ip" ] || { log "no ip after retries"; exit 1; }
[ "$(cat "$cache" 2>/dev/null)" = "$ip" ] && { log "unchanged $ip"; exit 0; }
GH_TOKEN=$(gh auth token --user joaquinrivero) || { log "gh token failed"; exit 1; }
export GH_TOKEN
printf '%s  %s\n' "$ip" "$(date)" > /tmp/mini-ip.txt
i=0
until gh gist edit "$gist" -f mini-ip.txt /tmp/mini-ip.txt; do
  i=$((i+1)); [ $i -ge 6 ] && { log "gist edit failed for $ip"; exit 1; }
  sleep 10
done
echo "$ip" > "$cache" && log "published $ip"
