#!/bin/sh
. /etc/os-release

build() {
    mkdir -p ~/src
    cd ~/src
    if [ ! -d helix ]; then
        git clone https://github.com/helix-editor/helix.git
    fi
    cd helix
    git pull

    # build it
    RUSTFLAGS="-C target-feature=-crt-static" cargo install --path helix-term --locked
}

case $ID in
"opensuse-tumbleweed")
    # be sure we're in the right distrobox container
    if [ "$CONTAINER_ID" != "tumbleweed" ]; then
        echo "run this in the default tumbleweed container"
        exit 1
    else
        zypper in cargo
        build
        sudo mv ~/.cargo/bin/hx /usr/bin/hx
        distrobox-export --bin /usr/bin/hx
    fi
    ;;
"aeon")
    echo "On Aeon - run this within the default tumbleweed distrobox. Terminating."
    exit 1
    ;;
"chimera")
    doas apk add cargo
    build
    doas mv ~/.cargo/bin/hx /usr/bin/hx
    ;;
"freebsd")
    doas pkg install -y rust
    build
    doas mv ~/.cargo/bin/hx /usr/bin/hx
    ;;
*)
    echo "Unknown operating system/distribution, terminating."
    exit 1
    ;;
esac

ln -svf ~/src/helix/runtime ~/.config/helix/runtime
