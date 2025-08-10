#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$SCRIPT_DIR/port_forwarding.rules"
ACTION="$1"  # "add" or "delete"

if [[ "$ACTION" == "add" ]]; then
    iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth+ -j MASQUERADE
elif [[ "$ACTION" == "delete" ]]; then
    iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth+ -j MASQUERADE
fi

while IFS=: read -r DEST_IP PORT PROTO; do
  if [[ "$ACTION" == "add" ]]; then
    iptables -t nat -A PREROUTING -p "$PROTO" --dport "$PORT" -j DNAT --to-destination "$DEST_IP:$PORT"
  elif [[ "$ACTION" == "delete" ]]; then
    iptables -t nat -D PREROUTING -p "$PROTO" --dport "$PORT" -j DNAT --to-destination "$DEST_IP:$PORT"
  fi
done < "$RULES_FILE"
