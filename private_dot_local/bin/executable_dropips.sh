#!/bin/bash
# NOTE: Use countryblock.sh to block the worst offenders
# Parses maillog, blocking auth violators and specific scam/spammers
cat <<EOF
dropips.sh:

This script scans logfiles for the following:

    - failed mail server authentication attempts
    - hosts attempting connection with or only offering insecure protocols
    - hosts attempting a http request to /wp-login...

... and adds a DROP rule to iptables.

In addition the script adds some hard coded IP addresses or address blocks
for prolific spammers.

The script attempts to insert an ACCEPT rule for your IP address.
EOF

read -p "Press any key to continue"

# don't block us/assumes only the sysadmin(s) or other authorized users have ssh access
DONTBLOCK=$(ss | grep ssh | grep ESTAB | awk '{print $6}' | cut -d ":" -f 1 | sort | uniq)

# mail system
echo "DROP smtp auth exploiters"
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

# http server
echo "DROP TLS exploit seekers"
for ip in $(grep "TLS handshake error.*unsupported" /var/log/socklog/messages/current | awk '{print $15}' | cut -d ":" -f 1 | sort | uniq); do
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
iptables -A INPUT -j DROP -s 194.169.175.0/24 # gb
iptables -A INPUT -j DROP -s 41.211.128.0/19  # ga porn bitcoin scam
iptables -A INPUT -j DROP -s 179.152.0.0/14   # br porn bitcoin scam
iptables -A INPUT -j DROP -s 196.176.0.0/14   # tn bitcoin porn scam
iptables -A INPUT -j DROP -s 157.245.0.0/16   # US - digital ocean
iptables -A INPUT -j DROP -s 5.79.64.0/18     # NL - Leaseweb
# spf and dmarc violators
iptables -A INPUT -j DROP -s 191.180.0.0/14  # br
iptables -A INPUT -j DROP -s 103.31.179.0/24 # bd
# msedge.exe / exploit
iptables -A INPUT -j DROP -s 212.102.40.0/23 # uk /dallas us
