#!/bin/sh
# a starting point config for any FreeBSD machine with extra functions for workstations and virtual machine support

HOSTNAME=$(hostname)
USER="mw"

pkgupdate() {
    # set to latest rather than updates
    mkdir -p /usr/local/etc/pkg/repos
    echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' >/usr/local/etc/pkg/repos/FreeBSD.conf
    pkg update -f
    pkg upgrade
}

baseconfig() {

    # on every machine
    pkg install -y doas git-lite chezmoi lazygit bash helix fish htop tmux rsync

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

    # disable
    echo 'kern.coredump=0' | tee -a /etc/sysctl.conf

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

    fi
    pkgupdate
}

fonts() {
    pkg install -y cantarell-fonts dejavu liberation-fonts-ttf nerd-fonts noto source-code-pro-ttf
}

audio() {
    pkg install -y mixertui
    # for mixertui, possibly other uses
    echo 'sysctlinfo_load="YES"' | tee -a /boot/loader.conf
    kldload sysctlinfo
    if [ "$(hostname)" = "elron" ]; then
        logger "setting mixer default to pcm11"
        sysctl hw.snd.default_unit=11
        cat <<EOF >>/etc/sysctl.conf
hw.snd.default_unit=11
EOF
    fi
}

wayland() {
    # running wayland here
    pw groupmod video -m $USER
    # minimal
    pkg install -y wayland seatd dbus foot kanshi river swaybg swayidle swaylock waybar fuzzel mako chromium

    # try to avoid this due to large dependencies
    # gnome-keyring
    sysrc dbus_enable="YES"
    service dbus start
    sysrc seatd_enable="YES"
    service seatd start
}

vmsupport() {
    # https://github.com/churchers/vm-bhyve
    pkg install -y vm-bhyve-devel
    zfs create -o mountpoint=/usr/local/vm zroot/vm
    sysrc vm_enable="YES"
    sysrc vm_dir="zfs:zroot/vm"
    vm init
    cp /usr/local/share/examples/vm-bhyve/* /usr/local/vm/.templates/
    vm switch create public
    vm switch add public ue0
}

widevine() {
    sysrc linux_enable="YES"
    service linux start
    # https://forums.freebsd.org/threads/watching-spotify-and-listening-to-netflix-in-2023.90695/
    pkg install foreign-cdm
    mkdir -p /home/$USER/src
    cd /home/$USER/src
    doas -u $USER git clone --depth 1 https://github.com/freebsd/freebsd-ports
    cd freebsd-ports/www/linux-widevine-cdm
    make || exit
    make install
    make clean
}

workstation() {
    echo "Enabling AMD and/or Intel GPUs; skipping NVIDIA (assuming used for passthrough)"
    if pciconf -lv | grep -B4 VGA | grep -e "vendor.*AMD"; then
        pkg install -y drm-kmod
        sysrc kld_list+=amdgpu
        kldload amdgpu
        echo "AMD GPU enabled (amdgpu)" | tee | logger
    fi
    if pciconf -lv | grep -B4 VGA | grep -ie "vendor.*intel"; then
        pkg install -y drm-kmod
        sysrc kld_list+=i915kms
        kldload i915kms
        echo "Intel GPU enabled (i915kms)" | tee | logger
    fi
    if pciconf -lv | grep -B4 VGA | grep -ie "vendor.*intel"; then
        echo "NVIDIA GPU IS NOT enabled - saved for PCI passthrough; look after this manually if wanted" | tee | logger
    fi

    # and...
    fonts
    audio
    wayland
    # widevine
}

echo "Configure real or virtual FreeBSD machines for basic server use or workstation.

    1. Set the USER variable in th script.
    2. Uncomment/enable one or more functions at the bottom of the script: $0
"

# uncomment one or more of these:
# baseconfig
# workstation
# vmsupport
