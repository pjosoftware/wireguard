#!/bin/bash

WG_PORT=$(grep '^WG_PORT=' ./env | cut -d '=' -f2)

if [[ -z "$WG_PORT" ]]; then
  echo "Error: WG_PORT not set in env file."
  exit 1
fi

sudo echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo ufw allow "${WG_PORT}/udp"
