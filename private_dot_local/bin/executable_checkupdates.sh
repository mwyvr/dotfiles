#!/bin/sh

. /etc/os-release
UPDATES="Updated $NAME packages available"

case $ID in
freebsd)
    doas pkg update >/dev/null
    if ! doas pkg upgrade --dry-run | grep -qi "up to date"; then
        notify-send -c critical "$UPDATES"
    fi
    ;;
"opensuse-tumbleweed")
    sudo zypper refresh >/dev/null
    if ! sudo zypper dup --dry-run | grep -qi "Nothing to do"; then
        notify-send -c critical "$UPDATES"
    fi
    ;;
esac
