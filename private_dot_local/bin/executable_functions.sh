#!/bin/sh
# reusble variables and functions for posix shells, no bashisms

. /etc/os-release

CPUTYPE=""
if lscpu | grep "GenuineIntel" >/dev/null 2>&1; then
    CPUTYPE="intel"
fi
if lscpu | grep "AuthenticAMD" >/dev/null 2>&1; then
    CPUTYPE="amd"
fi

# which su util to use
DOAS=""
if command -v sudo >/dev/null 2>&1; then
    DOAS=$(which sudo)
elif command -v doas >/dev/null 2>&1; then
    # chimera linux by default, others optionally
    DOAS=$(which doas)
fi
if [ -z "$DOAS" ]; then
    echo "cpugov: No sudo or doas available"
fi

case $ID in
"chimera")
    ADDCMD="$DOAS apk add"
    ;;
"opensuse-tumbleweed")
    ADDCMD="$DOAS zypper install"
    ;;
"void")
    ADDCMD="$DOAS xbps-install -Su"
    ;;
*)
    echo "Unsupported distribution $ID"
    exit 1
    ;;
esac


ask() {
    # usage:
    # if ! ask "Proceed with configuration? " Y; then
    #     echo "aborting"
    # else
    #     echo "proceeding"
    # fi

    if [ "$2" = 'Y' ]; then
        prompt='Y/n'
        default='Y'
    elif [ "$2" = 'N' ]; then
        prompt='y/N'
        default='N'
    else
        prompt='y/n'
        default=''
    fi

    while true; do
        echo "$1 [$prompt] "
        read -r reply </dev/tty
        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi
        case "$reply" in
        Y* | y*) return 0 ;;
        N* | n*) return 1 ;;
        esac
    done
}
