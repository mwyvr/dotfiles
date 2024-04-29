#!/bin/sh
# establish network connection via wg0
if [ ! -x "/usr/bin/nmcli" ]; then
	if [ ! -z $CONTAINER_ID ]; then
		echo "Running in container; run from host terminal instead."
	else
		echo "nmcli not found;"
	fi
	exit 1
fi
knockknock.sh
nmcli connection up "wg0"
