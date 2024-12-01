#!/bin/sh
KNOCKR="$HOME/go/bin/knockr"

. /etc/os-release

if [ ! -x "$KNOCKR" ]; then
    case $ID in
    "opensuse-tumbleweed")
        # dev tools in a distrobox
        if [ -z "${CONTAINER_ID}" ]; then
            exec "/bin/distrobox-enter" -n tumbleweed -- '/bin/go install github.com/mwyvr/knockr@latest'
        else
            go install github.com/mwyvr/knockr@latest
        fi
        ;;
    *)
        go install github.com/mwyvr/knockr@latest
        ;;
    esac
fi
# port knock router to open wireguard
. ~/.knock.env
$KNOCKR $KNOCKARGS
$KNOCKR $TESTARGS
