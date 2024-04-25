#!/usr/bin/sh
# install supports for neovim on various Linux distributions (Chimera Linux, Void Linux, openSUSE Tumbleweed/Aeon in a tw container)
. /etc/os-release
case $ID in
    chimera)
        doas apk update
        doas apk add neovim tmux go nodejs python-pip cargo fd ripgrep unzip wget curl wl-clipboard clang cmake
        # not in chimera cports (yet), mapped to space-l
        go install github.com/jesseduffield/lazygit@latest
        ;;
    void)
	    sudo xbps-install -Su neovim tmux go lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl wl-clipboard base-devel
        ;;
    "opensuse-tumbleweed")
        sudo zypper refresh
	    sudo zypper in neovim tmux go1.22 lazygit nodejs python312-pip cargo fd ripgrep unzip wget curl wl-clipboard gcc gcc-c++ make awk
        ;;
    "opensuse-aeon")
        echo "This system runs immutable openSUSE Aeon; run this script in a Tumbleweed container."
        ;;
    "opensuse-microos")
        echo "This system runs immutable openSUSE Aeon; run this script in a Tumbleweed container."
        ;;
    *)
        echo "Unknown Linux distribution, terminating."
        exit 1
        ;;
esac

