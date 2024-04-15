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

NOTE: Scans only *current* logs by default. To scan all logs break out of the 
script and restart as:

    dropips.sh all # or any argument

In addition the script adds some hard coded IP addresses or address blocks
for prolific spammers.

The script attempts to insert an ACCEPT rule for your IP address to avoid
locking out an admin.
EOF

read -p "Press any key to continue"

# don't block us/assumes only the sysadmin(s) or other authorized users have ssh access
DONTBLOCK=$(ss | grep ssh | grep ESTAB | awk '{print $6}' | cut -d ":" -f 1 | sort | uniq)

SCOPE="/var/log/socklog/messages/current"

if [ ! $# -eq 0 ]; then
	SCOPE="/var/log/socklog/messages/*"
fi

# mail system
echo "DROP smtp auth exploiters"
for ip in $(cat $SCOPE | grep "mox.*failed auth" | awk -F 'remote=| cid' '{print $2}' | sort | uniq); do
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

# http server; some are legit internet intel scans but who cares
echo "DROP TLS exploit seekers"
for ip in $(cat $SCOPE | grep "TLS handshake error.*unsupported" | awk '{ sub(/.* handshake error from /,""); sub(/:.*/,""); print }' | sort | uniq); do
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
iptables -A INPUT -j DROP -s 190.42.0.0/17    # pe bitcoin porn scam
iptables -A INPUT -j DROP -s 102.210.41.0/24  # ke bitcoin porn scam
iptables -A INPUT -j DROP -s 185.49.69.0/24   # gb - leaseweb
iptables -A INPUT -j DROP -s 5.79.64.0/18     # NL - Leaseweb
iptables -A INPUT -j DROP -s 178.162.128.0/18 # NL - Leaseweb
iptables -A INPUT -j DROP -s 81.171.0.0/19    # NL - Leaseweb
iptables -A INPUT -j DROP -s 37.48.78.87      # NL - Leaseweb
iptables -A INPUT -j DROP -s 62.210.0.0/16    # fr - Scaleway hosts malware, dns blocklisted
iptables -A INPUT -j DROP -s 163.172.0.0/16   # fr - Scaleway hosts malware, dns blocklisted
iptables -A INPUT -j DROP -s 192.119.160.0/20 # us - "madgenius.com" scam sender
iptables -A INPUT -j DROP -s 155.94.191.0/24  # us - "madgenius.com" scam sender
iptables -A INPUT -j DROP -s 165.140.240.0/22 # us - alphavps scam sender

# spf and dmarc violators
iptables -A INPUT -j DROP -s 191.180.0.0/14  # br
iptables -A INPUT -j DROP -s 103.31.179.0/24 # bd
# msedge.exe / exploit
iptables -A INPUT -j DROP -s 212.102.40.0/23 # uk /dallas us
