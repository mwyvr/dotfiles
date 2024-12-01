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

build_in_box() {
    # be sure we're in the right distrobox container
    if [ "$CONTAINER_ID" != "tumbleweed" ]; then
        echo "run this in the default tumbleweed container"
        exit 1
    else
        sudo zypper in -y cargo git patterns-devel-base-devel_basis
        build
        sudo mv ~/.cargo/bin/hx /usr/bin/hx
        distrobox-export --bin /usr/bin/hx
    fi
}

case $ID in
"opensuse-tumbleweed")
    build_in_box
    ;;
"aeon")
    build_in_box
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
