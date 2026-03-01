#!/bin/sh
. ~/.local/bin/functions.sh

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
  $DOAS rmdir /usr/lib64/helix/runtime
  $DOAS ln -svf $HOME/src/helix/runtime /usr/lib64/helix/
}

build_in_box() {
  if [ -z "$CONTAINER_ID" ]; then
    echo "run this in the default container"
    exit 1
  fi
}

case $ID in
"darwin")
  sudo port install cargo
  build
  sudo mv ~/.cargo/bin/hx /opt/local/bin/hx
  sudo ln -svf $HOME/src/helix/runtime /opt/local/bin/runtime
  ;;
"freebsd")
  doas pkg install -y rust
  build
  doas mv ~/.cargo/bin/hx /usr/local/bin/hx
  doas mkdir -p /usr/local/share/helix
  doas ln -svf $HOME/src/helix/runtime /opt/local/bin/runtime/helix
  ;;
"chimera")
  doas apk add cargo
  doas apk del helix
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
  $DOAS zypper rm -y helix
  build
  wrap
  ;;
"aeon")
  build_in_box
  distrobox-export --bin /usr/bin/hx
  ;;
*)
  echo "Unknown distribution [$ID]."
  # echo "Installing Helix (hx) and runtime files on host system"
  # echo "- be sure you have uninstalled the system Helix -"
  # # make it available to host system AND distroboxes by copying it
  # distrobox-host-exec $DOAS sh -c "cp $HOME/.cargo/bin/hx /usr/bin"
  # distrobox-host-exec $DOAS sh -c "mkdir -p /usr/lib/helix"
  # distrobox-host-exec $DOAS sh -c "ln -sv $HOME/src/helix/runtime /usr/lib/helix/"
  # ln -svf $HOME/src/helix/runtime $HOME/.config/helix/
  ;;
esac
