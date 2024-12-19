#!/bin/sh
# Appends valid ip addresses or netblocks to spammers table for firewall actions
SPAMMERS="/usr/local/etc/pftables/spammers"

addtotable() {
    if grep "$1" "$SPAMMERS"; then
        echo "$0: $1 already in table: $SPAMMERS"
    else
        # add to our persistent list
        echo "$1" | tee -a "$SPAMMERS"
        echo "$0: added $1 to table: $SPAMMERS"
        pfctl -t spammers -T replace -f spammers
    fi
    exit
}

if ! [ $(id -u) -eq 0 ]; then
    echo "$0: run as root"
    exit 1
fi

if ! [ "$1" ]; then
    echo "$0: no IP address/block provided"
    exit 1
fi

# netblock supplied, add it
if echo "$1" | grep -q -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\/[0-9]{1,2}'; then
    addtotable "$1"
fi

# no netblock supplied, check whois
if echo "$1" | grep -q -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'; then
    whois "$1"
    echo "$0: $1 was NOT added to spammers table; check whois info for a netblock instead."
    exit
fi

# fallthrough
echo "$0: $1 was NOT added to spammers table; is it valid?"
exit 1
