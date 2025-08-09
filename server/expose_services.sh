#!/bin/bash

CONFIG_FILE="services.conf"

while IFS=: read -r name destination port protocol; do
    # Skip empty lines or comments
    [[ -z "$name" || "$name" =~ ^# ]] && continue

    echo "Applying rule for $name: $protocol port $port → $destination:$port"
    iptables -t nat -A PREROUTING -p "$protocol" --dport "$port" -j DNAT --to-destination "$destination:$port"
done < "$CONFIG_FILE"