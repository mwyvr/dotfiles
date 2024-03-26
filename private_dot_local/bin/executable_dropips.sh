#!/bin/bash
# NOTE: Use countryblock.sh to block the worst offenders
# Parses maillog, blocking auth violators and specific scam/spammers

# don't block us/assumes only the sysadmin(s) or other authorized users have ssh access
DONTBLOCK=$(ss | grep ssh | grep ESTAB | awk '{print $6}' | cut -d ":" -f 1 | sort | uniq)
for ip in $(grep "mox.*failed auth" /var/log/socklog/messages/* | awk '{print $13}' | cut -d "=" -f 2 | sort | uniq); do
	case $ip in
	$DONTBLOCK)
		iptables -I INPUT -s $ip -j ACCEPT
		continue
		;;
	*)
		iptables -A INPUT -s $ip -j DROP
		echo $ip
		;;
	esac
done
# prolific spammers
iptables -A INPUT -j DROP -s 194.169.175.0/24 # gb
iptables -A INPUT -j DROP -s 41.211.128.0/19  # ga porn bitcoin scam
iptables -A INPUT -j DROP -s 179.152.0.0/14   # br porn bitcoin scam
iptables -A INPUT -j DROP -s 196.176.0.0/14   # tn bitcoin porn scam
# spf and dmarc violators
iptables -A INPUT -j DROP -s 191.180.0.0/14  # br
iptables -A INPUT -j DROP -s 103.31.179.0/24 # bd
