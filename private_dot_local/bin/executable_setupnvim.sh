#!/usr/bin/sh
# install supports for neovim on various Linux distributions (Chimera Linux, Void Linux, openSUSE Tumbleweed/Aeon in a tw container)
# helix as backup
. /etc/os-release

case $ID in
chimera)
    # doas apk update
    # doas apk add neovim helix fonts-nerd-roboto-mono go git nodejs python-pip cargo fd ripgrep unzip wget curl wl-clipboard clang cmake
    # # not in chimera cports (yet)
    # go install github.com/jesseduffield/lazygit@latest
    echo "Install in a distrobox"
    exit 1
    ;;
void)
    if [ -z "$DISPLAY" ]; then
        # probably a server
        sudo xbps-install -Su chezmoi neovim helix go lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl base-devel
    else
        sudo xbps-install -Su chezmoi neovim helix go lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl base-devel wl-clipboard
    fi
    ;;
"opensuse-tumbleweed")
    sudo zypper refresh
    sudo zypper in neovim helix chezmoi go git lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl wl-clipboard gcc gcc-c++ make
    if [ $CONTAINER_ID == "twbox" ]; then
         distrobox-export --bin /usr/bin/nvim
         distrobox-export --bin /usr/bin/chezmoi
    fi
    ;;
"aeon")
    echo "This system runs immutable openSUSE Aeon; run this script in the default Tumbleweed container."
    echo "e.g.:"
    echo "    distrobox enter"
    echo "    setupnvim.sh"
    ;;
"opensuse-microos")
    echo "This system runs immutable openSUSE MicroOS (Aeon); run this script in the default Tumbleweed container."
    echo "e.g.:"
    echo "    distrobox enter"
    echo "    setupnvim.sh"
    ;;
*)
    echo "Unknown Linux distribution; currently supports Chimera/Void/openSUSE Tumbleweed+Aeon. Terminating."
    exit 1
    ;;
esac
