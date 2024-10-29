#!/bin/sh
. /etc/os-release

case $ID in
"opensuse-tumbleweed")
    # be sure we're in the right distrobox container
    if [ "$CONTAINER_ID" != "tumbleweed" ]; then
        echo "run this in the default tumbleweed container"
        exit 1
    fi
    ;;
"aeon")
    echo "On Aeon - run this within the default tumbleweed distrobox. Terminating."
    exit 1
    ;;
"chimera")
    ;;
*)
    echo "Unknown Linux distribution, terminating."
    exit 1
    ;;
esac

mkdir -p ~/src
cd ~/src
if [ ! -d helix ]; then
    git clone https://github.com/helix-editor/helix.git
fi
cd helix
git pull

# build it
RUSTFLAGS="-C target-feature=-crt-static" cargo install --path helix-term --locked

# if on aeon/in a container
if [ "$CONTAINER_ID" = "tumbleweed" ]; then
    echo "Moving hx to /usr/bin"
    sudo mv ~/.cargo/bin/hx /usr/bin/hx
    distrobox-export --bin /usr/bin/hx
fi

ln -Tsvf ~/src/helix/runtime ~/.config/helix/runtime
