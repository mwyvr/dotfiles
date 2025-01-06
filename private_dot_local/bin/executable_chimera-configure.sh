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
$ADDCMD chimera-repo-user
doas apk upgrade --no-interactive
doas dinitctl enable chrony
doas dinitctl enable syslog-ng

# cpu microcode
if lscpu | grep "GenuineIntel"; then
    $ADDCMD ucode-intel
fi
if lscpu | grep "AuthenticAMD"; then
    $ADDCMD ucode-amd
fi

# core utils
$ADDCMD git lazygit delta chezmoi fish-shell btop htop
# for Helix editor and dev
$ADDCMD helix go nodejs cargo

# Desktop for me means development workstation and virtual machine host
if [ -n "$IS_DESKTOP" ]; then
    doas dinitctl enable sshd

    # my Varmilo keyboard firmware IDs as an Apple; the function keys act as
    # media keys unless pressed with Fn button, which is annoying.
    VARMILO=$(lsmod | grep Varmilo)
    if [ -z "$VARMILO" ]; then
        echo "- Forcing Varmilo/hid_apple function keys as default (2)"
        # real time temp fix
        echo 2 >/sys/module/hid_apple/parameters/fnmode
        # make fix permanent
        echo "options hid_apple fnmode=2" | tee -a /etc/modprobe.d/$(hostname).conf
    fi

    if ask "Prevent machine from sleeping?" Y; then
        # ensure machine does not suspend at gdm login prompt; if this doesn't work, disable in /etc/elogind
        # doas -u _gdm dbus-run-session gsettings set org.gnome.desktop.session idle-delay 0 # default 300 (s) / 5 min

        doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0
        doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
        doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0
        doas -u _gdm dbus-run-session gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'
        # the above isn't doing the job so we'll brute for it here for now:
        # if ! grep -q "AllowSuspend=no" /etc/elogind/sleep.conf; then
        # echo "AllowSuspend=no" | doas tee -a /etc/elogind/sleep.conf
        # fi
    fi

    if ask "Include kvm/qemu/virt-manager?" Y; then
        # kvm/qemu virtual machine support
        $ADDCMD qemu qemu-edk2-firmware qemu-system-x86_64 libvirt virt-manager virt-viewer ufw
        doas usermod -aG kvm,libvirt $USER
        # virtlockd and virtlogd are enabled automatically by the following
        for svc in virtqemud virtnodedevd virtstoraged virtnetworkd; do
            doas dinitctl enable $svc
        done
    fi
fi

# Desktop and laptop get these
if [ -n "$IS_GUI" ]; then
    $ADDCMD foot fonts-nerd-roboto-mono
    # applications
    $ADDCMD evolution
    # flatpak apps
    $ADDCMD flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    for app in org.chromium.Chromium org.signal.Signal us.zoom.Zoom; do
        echo "Installing $app"
        flatpak install -y $app
    done
fi
# laptop specific (mine are all Intel igpu)
if [ -n "$IS_LAPTOP" ]; then
    $ADDCMD intel-media-driver
fi

# after microcode
doas update-initramfs -c -k all

echo ""
echo "Configuration complete. Reboot when ready."
