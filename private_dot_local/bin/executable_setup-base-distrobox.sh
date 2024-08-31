#!/bin/sh
# Sets up an already existing "twbox" with basic cli applications
sudo zypper -n install helix go chezmoi git nodejs whois
distrobox-export --bin /usr/bin/helix
distrobox-host-exec ln -svf ~/.local/bin/helix ~/.local/bin/hx
distrobox-export --bin /usr/bin/chezmoi
distrobox-export --bin /usr/bin/git
