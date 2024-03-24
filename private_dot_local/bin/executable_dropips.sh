#!/bin/sh
# NOTE: Use countryblock.sh to block the worst offenders
for ip in $(grep "mox.*failed auth" /var/log/socklog/messages/* | awk '{print $13}' | cut -d "=" -f 2 | sort | uniq); do
	iptables -A INPUT -s $ip -j DROP
	echo $ip
done
# prolific spammers
iptables -A INPUT -j DROP -s 194.169.175.0/24 # gb
iptables -A INPUT -j DROP -s 41.211.128.0/19  # ga porn bitcoin scam
iptables -A INPUT -j DROP -s 179.152.0.0/14   # br porn bitcoin scam
iptables -A INPUT -j DROP -s 196.176.0.0/14   # tn bitcoin porn scam
# spf and dmarc violators
iptables -A INPUT -j DROP -s 191.180.0.0/14  # br
iptables -A INPUT -j DROP -s 103.31.179.0/24 # bd
