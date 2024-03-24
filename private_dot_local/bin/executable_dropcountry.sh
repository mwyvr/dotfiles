#!/bin/bash
# Adds country (use country code) to iptables without purging iptables
BASE_URL="https://www.ipdeny.com/ipblocks/data/aggregated/"
URL_SUFFIX="-aggregated.zone"

URL="$BASE_URL$1$URL_SUFFIX"
echo $URL
for ip in $(curl $URL); do
	iptables -A INPUT -j DROP -s $ip
done
