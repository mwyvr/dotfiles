#!/bin/sh
# check if in distrobox
if [ -z $CONTAINER_ID ]; then
	nmcli connection down "wg0"
else
	distrobox-host-exec nmcli connection down "wg0"
fi
