#!/bin/sh
# a starting point config

HOSTNAME=$(hostname)
USER="mw"

pkgupdate() {
    # set to latest rather than updates
    mkdir -p /usr/local/etc/pkg/repos
    echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' >/usr/local/etc/pkg/repos/FreeBSD.conf
    pkg update -f
}

baseconfig() {

    # on every machine
    pkg install doas git-lite chezmoi lazygit bash helix fish htop tmux rsync

    # prevent use of weaker key types
    rm /etc/ssh/ssh_host_*
    sysrc sshd_dsa_enable="no"
    sysrc sshd_ecdsa_enable="no"
    sysrc sshd_ed25519_enable="yes"
    sysrc sshd_rsa_enable="yes"
    service sshd keygen
    service sshd restart

    # @ me if you want
    cat <<EOF >/usr/local/etc/doas.conf
permit nopass :wheel
EOF

    # real hardware not vm
    if ! sysctl -a | grep -iq "virt"; then

        sysrc microcode_update_enable=YES
        service microcode_update start

        if sysctl hw.model | grep "Intel"; then
            echo 'coretemp_load="YES"' | tee -a /boot/loader.conf
        fi
        if sysctl hw.model | grep -i "AMD"; then
            echo 'amdtemp_load="YES"' | tee -a /boot/loader.conf
        fi

        # echo "setting default sound output, check /etc/sysctl.conf"
        if [ "$HOSTNAME" = "elron" ]; then
            sysctl hw.snd.default_unit=11
            cat <<EOF >>/etc/sysctl.conf
hw.snd.default_unit=11
EOF
        fi
    fi
}

fonts() {
    pkg install -y nerd-fonts noto liberation-fonts-ttf cantarell-fonts source-code-pro-ttf dejavu
}

widevine() {
    # https://forums.freebsd.org/threads/watching-spotify-and-listening-to-netflix-in-2023.90695/
    pkg install foreign-cdm
    mkdir -p /home/$USER/src
    cd /home/$USER/src
    doas -u $USER git clone --depth 1 https://github.com/freebsd/freebsd-ports
    cd freebsd-ports/www/linux-widevine-cdm
    doas -u $USER make
    make install
}

workstation() {
    # we'll be running some things...
    # sysrc linux_enable="YES"
    # service linux start
    echo "Enabling AMD and/or Intel GPUs; skipping NVIDIA (assuming used for passthrough)"
    if pciconf -lv | grep -B4 VGA | grep -e "vendor.*AMD"; then
        pkg install -y drm-kmod
        sysrc kld_list+=amdgpu
        kldload amdgpu
        echo "AMD GPU enabled (amdgpu)" | tee logger
    fi
    if pciconf -lv | grep -B4 VGA | grep -ie "vendor.*intel"; then
        pkg install -y drm-kmod
        sysrc kld_list+=i915kms
        kldload i915kms
        echo "Intel GPU enabled (i915kms)" | tee logger
    fi
    if pciconf -lv | grep -B4 VGA | grep -ie "vendor.*intel"; then
        echo "NVIDIA GPU IS NOT enabled - saved for PCI passthrough; look after this manually if wanted" | tee logger
    fi

    # running wayland here
    pw groupmod video -m $USER
    # minimal
    pkg install wayland seatd dbus foot river i3bar-river fuzzel mako chromium
    # try to avoid this due to large dependencies
    # gnome-keyring
    sysrc dbus_enable="YES"
    service dbus start
    sysrc seatd_enable="YES"
    service seatd start

    fonts
}

echo "enable one or more functions in the script $0"
echo "TODO - add balance of packages and put root test"
# pkgupdate
# baseconfig
# workstation
# widevine
