#!/bin/sh
. /etc/os-release

NUM=""
PACKAGES=""

case $ID in
freebsd)
    doas pkg update -f >/dev/null
    APP="pkg"
    PACKAGES="$(pkg upgrade --dry-run | grep -Eo \"^[[:space:]]+(.*)\")"
    NUM=$(doas pkg upgrade --dry-run | grep -Eo "The following ([0-9]+) package\(s\) will be affected" | cut -d ' ' -f 3)
    ;;
"opensuse-tumbleweed")
    sudo zypper refresh >/dev/null
    APP="zypper"
    NUM=$(sudo zypper --non-interactive dup --dry-run | grep -Eo "The following ([0-9]+) package" | cut -d ' ' -f 3)
    ;;
"chimera")
    doas apk update -q >/dev/null
    APP="apk"
    PACKAGES=$(doas apk upgrade -s | grep -v "^OK")
    NUM=$(echo $PACKAGES | wc -l | xargs)
    ;;
"void")
    APP="xbps"
    NUM=$(sudo xbps-install -Su --dry-run | wc -l) # update repo & get count
    for p in $( # no repo hit, no sudo needed either
        xbps-install -u --dry-run | cut -f 1 -d ' '
    ); do
        PACKAGES="${PACKAGES:+${PACKAGES}\n}${p}"
    done

    ;;
*)
    if [ -n "$DBUS_SESSION_BUS_ADDRESS" ]; then
        notify-send "$0: unsupported $NAME"
    fi
    echo "$0: $NAME is unsupported"
    exit
    ;;
esac

if [ -n "$NUM" ]; then
    # for status bar
    echo $NUM
    if [ -n "$DBUS_SESSION_BUS_ADDRESS" ] && [ "$NUM" != "0" ]; then
        notify-send -a "$APP" "System Updates" "$NUM updates are available for $NAME\n\n$PACKAGES"
    fi
fi
