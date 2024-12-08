#!/bin/sh
. /etc/os-release

NUM=""

case $ID in
freebsd)
    doas pkg update >/dev/null
    NUM=$(doas pkg upgrade --dry-run | grep -Eo "The following ([0-9]+) package\(s\) will be affected" | cut -d ' ' -f 3)
    ;;
"opensuse-tumbleweed")
    sudo zypper refresh >/dev/null
    NUM=$(sudo zypper --non-interactive dup --dry-run | grep -Eo "The following ([0-9]+) package" | cut -d ' ' -f 3)
    ;;
"chimera")
    doas apk update -q >/dev/null
    NUM=$(doas apk upgrade -s | grep -E -c "([0-9]+/[0-9]+)")
    ;;
"void")
    NUM=$(sudo xbps-install -Su --dry-run | wc -l)
    ;;
*)
    notify-send --transient "$0: unsupported $NAME"
    exit
    ;;
esac

if ! [ "$NUM" = "" ]; then
    notify-send --transient "$NUM system updates are available for $NAME"
fi
