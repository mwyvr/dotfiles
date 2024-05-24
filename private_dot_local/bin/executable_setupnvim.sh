#!/usr/bin/sh
# install supports for neovim on various Linux distributions (Chimera Linux, Void Linux, openSUSE Tumbleweed/Aeon in a tw container)
# helix as backup
. /etc/os-release

case $ID in
chimera)
	doas apk update
	doas apk add neovim helix go git nodejs python-pip cargo fd ripgrep unzip wget curl wl-clipboard clang cmake awk
	# not in chimera cports (yet)
	go install github.com/jesseduffield/lazygit@latest
	;;
void)
	if [ -z "$DISPLAY" ]; then
		# probably a server
		sudo xbps-install -Su neovim helix go lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl base-devel
	else
		sudo xbps-install -Su neovim helix go lazygit nodejs python3-pip cargo fd ripgrep unzip wget curl base-devel wl-clipboard
	fi
	;;
"opensuse-tumbleweed")
	sudo zypper refresh
	sudo zypper in neovim helix go1.22 git lazygit nodejs python312-pip cargo fd ripgrep unzip wget curl wl-clipboard gcc gcc-c++ make
	if [ $CONTAINER_ID == "tumbleweed" ]; then
		distrobox-export --bin /usr/bin/nvim
	fi
	;;
"opensuse-aeon")
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
