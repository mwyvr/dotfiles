#!/bin/sh

. ~/.local/bin/functions.sh

ADDCMD="doas apk add --no-interactive"
IS_SERVER=""
IS_DESKTOP=""
IS_LAPTOP=""
IS_GUI=""

echo "Configure Chimera Linux for laptop, desktop, or server use"
if [ -d "/proc/acpi/button/lid" ]; then
    IS_LAPTOP="y"
    IS_GUI="y"
else
    if ask "Is this a server?" N; then
        IS_SERVER="y"
    else
        IS_DESKTOP="y"
        IS_GUI="y"
    fi
fi

echo "IS_SERVER: " $IS_SERVER
echo "IS_DESKTOP: " $IS_DESKTOP
echo "IS_LAPTOP: " $IS_LAPTOP
if ! ask "Continue with installation and configuration? " Y; then
    echo "Aborting"
    exit 1
fi

# Adds necessary packages and services for all types of systems
doas apk update
doas apk upgrade --no-interactive
$ADDCMD chrony
doas dinitctl enable chrony
doas dinitctl enable syslog-ng

# cpu microcode
if lscpu | grep "GenuineIntel"; then
    $ADDCMD ucode-intel
else
    $ADDCMD ucode-amd
fi

# core utils
$ADDCMD git chezmoi fish-shell btop distrobox
# for Helix editor and dev
$ADDCMD helix go nodejs cargo
# lazygit not yet in cports
go install github.com/jesseduffield/lazygit@latest

# Desktop for me means development workstation and virtual machine host
if [ -n "$IS_DESKTOP" ]; then
    doas dinitctl enable sshd

    if ask "Prevent machine from sleeping?" Y; then
        # ensure machine does not suspend at gdm login prompt; may need to configure /etc/elogind
        doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
        doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
        # the above isn't doing the job so we'll brute for it here for now:
        if ! grep -q "AllowSuspend=no" /etc/elogind/sleep.conf; then
            echo "AllowSuspend=no" | doas tee -a /etc/elogind/sleep.conf
        fi
    fi

    if ask "Include kvm/qemu/virt-manager?" Y; then
        # kvm/qemu virtual machine support
        $ADDCMD qemu qemu-edk2-firmware qemu-system-x86_64 libvirt virt-manager virt-viewer ufw
        doas usermod -aG kvm libvirt $USER
        # virtlockd and virtlogd are enabled automatically by the following
        for svc in virtqemud virtnodedevd virtstoraged virtnetworkd; do
            dinitctl enable $svc
        done
    fi
fi

# Desktop and laptop get these
if [ -n "$IS_GUI" ]; then
    $ADDCMD foot gnome-tweaks fonts-nerd-roboto-mono
    # applications
    $ADDCMD evolution
    # flatpak apps
    $ADDCMD flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    for app in com.google.Chrome org.signal.Signal us.zoom.Zoom; do
        echo "Installing $app"
        flatpak install -y $app
    done
fi

# after microcode
doas update-initramfs -c -k all

echo ""
echo "Configuration complete. Reboot when ready."
