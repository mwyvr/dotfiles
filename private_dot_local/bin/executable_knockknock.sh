#!/bin/sh
KNOCKR="$HOME/go/bin/knockr"
DISTROBOX="arch"

. /etc/os-release

distrobox_build() {
    # if not in a container, enter it to build the app
    if [ -z "${CONTAINER_ID}" ]; then
        distrobox-enter -n $DISTROBOX -- /bin/go install github.com/mwyvr/knockr@latest
    else
        if ! type go >/dev/null; then
            echo "$0: go is not installed in distrobox [$DISTROBOX], terminating"
            exit 1
        fi
        go install github.com/mwyvr/knockr@latest
    fi
}

if [ ! -x "$KNOCKR" ]; then
    case $ID in
    aeon | "opensuse-tumbleweed")
        DISTROBOX="tumbleweed"
        distrobox_build
        ;;
    *)
        if ! type go >/dev/null; then
            echo "$0: go is not installed, terminating"
            exit 1
        fi
        go install github.com/mwyvr/knockr@latest
        ;;
    esac
fi
# port knock router to open wireguard - not strictly necessary
. ~/.knock.env
$KNOCKR $KNOCKARGS
$KNOCKR $TESTARGS
