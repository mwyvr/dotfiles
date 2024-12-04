#!/bin/sh
. /etc/os-release

UPDATES="system updates are available for $NAME."

case $ID in
freebsd)
    doas pkg update >/dev/null
    NUM=$(doas pkg upgrade --dry-run | grep -Eo "The following ([0-9].) package\(s\) will be affected" | cut -d ' ' -f 3)
    if ! [ "$NUM" = "" ]; then
        notify-send -c critical "$NUM $UPDATES"
    fi
    ;;
"opensuse-tumbleweed")
    sudo zypper refresh >/dev/null
    NUM=$(sudo zypper dup --dry-run | grep -Eo "The following ([0-9].) package" | cut -d ' ' -f 3)
    if ! [ "$NUM" = "" ]; then
        notify-send -c critical "$NUM $UPDATES"
    fi
    ;;
esac
