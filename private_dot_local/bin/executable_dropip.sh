#!/bin/bash
if [ $# -eq 0 ]; then
	echo "dropip.sh: error, no ip or ip block supplied as argument"
fi
ip=$1

# don't block us/assumes only the sysadmin(s) or other authorized users have ssh access
DONTBLOCK=$(ss | grep ssh | grep ESTAB | awk '{print $6}' | cut -d ":" -f 1 | sort | uniq)

case "$ip" in
$DONTBLOCK)
	iptables -C INPUT -j ACCEPT -s "$ip" >/dev/null 2>&1 || iptables -I INPUT -s "$ip" -j ACCEPT
	;;
*)
	# Adds an ip or /netblock to iptables drop list, if it isn't already in there
	if ! iptables -C INPUT -j DROP -s "$ip" >/dev/null 2>&1; then
		iptables -A INPUT -j DROP -s "$ip"
		echo "dropip.sh DROP $ip"
		logger "dropip.sh DROP $ip"
	else
		echo "$ip already in iptables INPUT DROP rule"
	fi
	;;
esac
