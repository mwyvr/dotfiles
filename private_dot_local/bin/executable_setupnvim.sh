#!/usr/bin/sh
# install supports for neovim on various Linux distributions (Chimera Linux, Void Linux, openSUSE)
. /etc/os-release
if [ $ID = "chimera" ]; then
	doas apk update
	doas apk add go nodejs python-pip cargo fd ripgrep unzip wget curl wl-clipboard clang cmake
    # not in chimera cports (yet), mapped to space-l
    go install github.com/jesseduffield/lazygit@latest
elif [ $ID = "void" ]; then
	sudo xbps-install -Su go nodejs python3-pip cargo fd ripgrep unzip wget curl wl-clipboard base-devel
elif [ $ID = "opensuse-tumbleweed" ]; then
	sudo zypper in go1.22 nodejs python312-pip cargo fd ripgrep unzip wget curl wl-clipboard gcc gcc-c++ make
elif [ $ID = "opensuse-aeon" ]; then
    echo "This system runs immutable openSUSE Aeon; run this script in a container."
else
	echo "Unknown Linux distribution, terminating."
	exit 1
fi
