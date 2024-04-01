#!/bin/sh
# establish network connection via wg0
knockknock.sh
nmcli connection up "wg0"
