#!/bin/bash
echo "dropips.sh"
# NOTE: Use countryblock.sh to block the worst offenders
# Parses maillog, blocking auth violators and specific scam/spammers
#
# This script scans logfiles for the following:
#
#     - failed mail server authentication attempts
#     - hosts attempting connection with or only offering insecure protocols
#     - hosts attempting a http request to /wp-login...
#
# ... and adds a DROP rule to iptables.
#
# In addition the script adds some hard coded IP addresses or address blocks
# for prolific spammers.
#
# The script attempts to insert an ACCEPT rule for your IP address to avoid
# locking out an admin.
# EOF

# new blocks
COUNT=0

# don't block us/assumes only the sysadmin(s) or other authorized users have ssh access
DONTBLOCK=$(ss | grep ssh | grep ESTAB | awk '{print $6}' | cut -d ":" -f 1 | sort | uniq)

SCOPE="/var/log/socklog/messages/current"
logger "dropips.sh starting"

# if any command line argument, process all the log files current and past
if [ ! $# -eq 0 ]; then
	SCOPE="/var/log/socklog/messages/*"
fi

# mail system
for ip in $(cat $SCOPE | grep "mox.*failed auth" | awk -F 'remote=| cid' '{print $2}' | sort | uniq); do
	case "$ip" in
	$DONTBLOCK)
		iptables -C INPUT -j ACCEPT -s "$ip" >/dev/null 2>&1 || iptables -I INPUT -s "$ip" -j ACCEPT
		continue
		;;
	*)
		# Adds an ip or /netblock to iptables drop list, if it isn't already in there
		if ! iptables -C INPUT -j DROP -s "$ip" >/dev/null 2>&1; then
			iptables -A INPUT -j DROP -s "$ip"
			logger "mox failed auth DROP $ip"
			let COUNT++
		fi
		;;
	esac
done

# http server; some are legit internet intel scans but who cares
for ip in $(cat $SCOPE | grep "TLS handshake error.*unsupported" | awk '{ sub(/.* handshake error from /,""); sub(/:.*/,""); print }' | sort | uniq); do
	case $ip in
	$DONTBLOCK)
		iptables -C INPUT -j ACCEPT -s "$ip" >/dev/null 2>&1 || iptables -I INPUT -s "$ip" -j ACCEPT
		continue
		;;
	*)
		# Adds an ip or /netblock to iptables drop list, if it isn't already in there
		if ! iptables -C INPUT -j DROP -s "$ip" >/dev/null 2>&1; then
			iptables -A INPUT -j DROP -s "$ip"
			logger "mox unsupported HTTP TLS DROP $ip"
			let COUNT++
		fi
		;;
	esac
done

BADACTORS=(
	# prolific spammers
	"194.169.175.0/24" # gb
	"194.169.175.4"    # gb
	"194.169.175.0/24" # gb
	"41.211.128.0/19"  # ga porn bitcoin scam
	"179.152.0.0/14"   # br porn bitcoin scam
	"196.176.0.0/14"   # tn bitcoin porn scam
	"190.42.0.0/17"    # pe bitcoin porn scam
	"102.210.41.0/24"  # ke bitcoin porn scam
	"176.88.185.0/24"  # tr bitcoin porn scam
	"185.49.69.0/24"   # gb - leaseweb
	"5.79.64.0/18"     # NL - Leaseweb
	"178.162.128.0/18" # NL - Leaseweb
	"81.171.0.0/19"    # NL - Leaseweb
	"37.48.78.87"      # NL - Leaseweb
	"62.210.0.0/16"    # fr - Scaleway hosts malware, dns blocklisted
	"163.172.0.0/16"   # fr - Scaleway hosts malware, dns blocklisted
	"192.119.160.0/20" # us - "madgenius.com" scam sender
	"155.94.191.0/24"  # us - "madgenius.com" scam sender
	"165.140.240.0/22" # us - alphavps scam sender
	"109.71.254.0/24"  # de - emeraldhost.de apple ID phishing scammer
	"41.61.0.0/17"     # hu/sa - grindhost - canadapost/intelcom phishing scammer; viagra
	# notable smtp connections without purpose
	"193.222.96.0/24" # fr contantmoulin, 4000 connections over several days
	# auth violators
	"111.0.0.0/10"   # cn - china mobile
	"27.115.0.0/17"  # cn - china unicom
	"80.244.11.0/24" # ir - iran posing as nl
	# spf and dmarc violators
	"191.180.0.0/14"  # br
	"103.31.179.0/24" # bd
	# # msedge.exe / exploit
	"212.102.40.0/23" # uk /dallas us
)

for ip in "${BADACTORS[@]}"; do
	case $ip in
	$DONTBLOCK)
		iptables -C INPUT -j ACCEPT -s "$ip" >/dev/null 2>&1 || iptables -I INPUT -s "$ip" -j ACCEPT
		continue
		;;
	*)
		# Adds an ip or /netblock to iptables drop list, if it isn't already in there
		if ! iptables -C INPUT -j DROP -s "$ip" >/dev/null 2>&1; then
			iptables -A INPUT -j DROP -s "$ip"
			logger "mox known bad actors DROP $ip"
			let COUNT++
		fi
		;;
	esac
done
logger "dropips.sh finished, $COUNT DROP rules added"
