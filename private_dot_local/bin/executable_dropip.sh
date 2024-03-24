#!/bin/sh
iptables -A INPUT -j DROP -s $1
