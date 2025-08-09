#!/bin/bash

sudo echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo ufw allow 51820/udp