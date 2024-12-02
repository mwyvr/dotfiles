#!/bin/sh
KNOCKR="$HOME/go/bin/knockr"

. /etc/os-release

distrobox_build() {
    # if not in a container, enter it
    if [ -z "${CONTAINER_ID}" ]; then
        distrobox-enter -n tumbleweed -- /bin/go install github.com/mwyvr/knockr@latest
    else
        go install github.com/mwyvr/knockr@latest
    fi
}

if [ ! -x "$KNOCKR" ]; then
    case $ID in
    "opensuse-tumbleweed")
        distrobox_build
        ;;
    "aeon")
        distrobox_build
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
