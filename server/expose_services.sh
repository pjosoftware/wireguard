#!/bin/bash

CONFIG_FILE="services.conf"

while IFS=: read -r name destination port protocol || [ -n "$name" ]; do
    # Skip empty or commented lines
    [[ -z "$name" || "$name" =~ ^# ]] && continue

    protocol="${protocol//$'\r'/}"

    echo "iptables -t nat -A PREROUTING -p $protocol --dport $port -j DNAT --to-destination $destination:$port"
    iptables -t nat -A PREROUTING -p "$protocol" --dport "$port" -j DNAT --to-destination "$destination:$port"
done < "$CONFIG_FILE"
