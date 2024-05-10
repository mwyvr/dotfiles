#!/bin/sh
# Port knocks to open remote device then makes Wireguard connection; operates on
# traditional distributions and distrobox-enabled such as openSUSE Aeon
KNOCKR="$HOME/go/bin/knockr"
if [ ! -x "$KNOCKR" ]; then
	# not in a container
	if [ -z $CONTAINER_ID ]; then
		# innocuous binary, requires Go be installed (and exported)
		go install github.com/mwyvr/knockr@latest
	else
		distrobox-enter --name tumbleweed -- go install github.com/mwyvr/knockr@latest
	fi
fi
# port knock router to open wireguard port on destination device, kept a secret from github
. ~/.knock.env
$KNOCKR $KNOCKARGS
$KNOCKR $TESTARGS

# establish network connection via wg0
# check if in distrobox
if [ -z $CONTAINER_ID ]; then
	if [ ! -x "/usr/bin/nmcli" ]; then
		echo "nmcli not found; install on host or via transactional-update on Aeon"
		exit 1
	fi
	nmcli connection up "wg0"
else
	if ! distrobox-host-exec nmcli connection up "wg0"; then
		echo not found
	else
		echo "nmcli not found; install on host or via transactional-update on Aeon"
		exit 1
	fi
fi
