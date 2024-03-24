#!/bin/sh
# Adds an ip or /netblock to iptables drop list
iptables -A INPUT -j DROP -s $1
