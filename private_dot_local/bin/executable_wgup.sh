#!/bin/sh
# establish network connection to home
knockknock.sh
nmcli connection up "Wireguard-Home"
