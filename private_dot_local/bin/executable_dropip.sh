#!/bin/bash
# Adds an ip or /netblock to iptables drop list, if it isn't already in there
iptables -C INPUT -j DROP -s "$ip" >/dev/null 2>&1 || iptables -A INPUT -j DROP -s "$ip"
