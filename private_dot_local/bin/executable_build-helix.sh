#!/bin/sh
. /etc/os-release

# default on Chimera; by choice on FreeBSD and Void; not available on openSUSE
DOAS="doas"

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

wrap() {

    cat <<EOF | $DOAS tee /usr/bin/hx
#!/bin/sh
HELIX_RUNTIME=/usr/lib64/helix/runtime helix "\$@"
EOF
    $DOAS chmod +x /usr/bin/hx
    $DOAS mv ~/.cargo/bin/hx /usr/bin/helix
    $DOAS mkdir -p /usr/lib64/helix
    $DOAS ln -svf $HOME/src/helix/runtime /usr/lib64/helix/
}

build_in_box() {
    echo "Assumes an Arch Linux distrobox"
    if [ -z "$CONTAINER_ID" ]; then
        echo "run this in the default container"
        exit 1
    else
        $DOAS pacman -Syu base-devel git rust
        build
    fi
}

case $ID in
"freebsd")
    doas pkg install -y rust
    build
    doas mv ~/.cargo/bin/hx /usr/local/bin/hx
    doas mkdir -p /usr/local/share/helix
    doas ln -svf $HOME/src/helix/runtime /usr/local/share/helix
    ;;
"chimera")
    doas apk add cargo
    build
    wrap
    ;;
"void")
    $DOAS xbps-install -Suy cargo
    build
    wrap
    ;;
"opensuse-tumbleweed")
    DOAS=sudo
    $DOAS zypper in -y cargo
    build
    wrap
    ;;
*)
    build_in_box
    echo "Installing Helix (hx) and runtime files on host system"
    echo "- be sure you have uninstalled the system Helix -"
    # make it available to host system AND distroboxes by copying it
    distrobox-host-exec $DOAS sh -c "cp $HOME/.cargo/bin/hx /usr/bin"
    distrobox-host-exec $DOAS sh -c "mkdir -p /usr/lib/helix"
    distrobox-host-exec $DOAS sh -c "ln -sv $HOME/src/helix/runtime /usr/lib/helix/"
    ln -svf $HOME/src/helix/runtime $HOME/.config/helix/
    ;;
esac
