#!/bin/sh
# wgtoggle.sh activates or deactivates the wg0 connection
# nmcli must be installed in the host OS (not a Distrobox container)
UPCMD="nmcli connection up wg0"
DOWNCMD="nmcli connection down wg0"

con_up() {
	if [ -z "${CONTAINER_ID}" ]; then
		# running in the host os such as openSUSE Aeon or standard distribution
		if [ ! -x "/usr/bin/nmcli" ]; then
			echo "nmcli not installed on host (not container) OS"
			exit 1
		fi
		$UPCMD
	else
		exec distrobox-host-exec $UPCMD
	fi
}

con_down() {
	if [ -z "${CONTAINER_ID}" ]; then
		# running in the host os such as openSUSE Aeon or standard distribution
		$DOWNCMD
	else
		exec distrobox-host-exec $DOWNCMD
	fi
}

if [ -z "${CONTAINER_ID}" ]; then
	if [ ! -x "/usr/bin/nmcli" ]; then
		echo "nmcli not installed on host (not container) OS"
		exit 1
	fi
fi

nmcli connection show --active | grep wg0 >/dev/null
# exitcode=$?
if [[ $? -eq 0 ]]; then
	con_down
else
	knockknock.sh
	con_up
fi
