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
    echo "Assumes an Arch Linux distrobox"
    if [ -z "$CONTAINER_ID" ]; then
        echo "run this in the default container"
        exit 1
    else
        sudo pacman -Syu base-devel git rust
        build
    fi
}

case $ID in
"freebsd")
    doas pkg install -y rust
    build
    doas mv ~/.cargo/bin/hx /usr/local/bin/hx
    ;;
"chimera")
    doas apk add cargo
    build
    doas mv ~/.cargo/bin/hx /usr/bin/hx
    ;;
*)
    build_in_box
    echo "Installing Helix (hx) and runtime files on host system"
    echo "- be sure you have uninstalled the system Helix -"
    # make it available to host system AND distroboxes by copying it
    distrobox-host-exec sudo sh -c "cp $HOME/.cargo/bin/hx /usr/bin"
    distrobox-host-exec sudo sh -c "mkdir -p /usr/lib/helix"
    distrobox-host-exec sudo sh -c "ln -sv $HOME/src/helix/runtime /usr/lib/helix/"
    ln -svf $HOME/src/helix/runtime $HOME/.config/helix/
    ;;
esac
