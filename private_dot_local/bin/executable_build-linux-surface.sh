#!/bin/sh
# build-linux-surface.sh
#
# Creates a temporary linux-stable-surface branch, applies and builds with
# the latest patches from the linux-surface project.
# https://github.com/linux-surface/linux-surface

CPORTS_PATH="$HOME/cports"
BRANCH="linux-stable"
SURFACE="linux-stable-surface"
VER="6.11"

copy_linux() {
    # currently have no plans to track changes, but in case of accidental
    # commit, force switch/reset to a branch
    if ! git switch -C "$SURFACE"; then
        echo "Can't switch to $SURFACE branch"
        exit 1
    fi
    cd "$CPORTS_PATH"/main || exit 1
    rm -rf "$SURFACE"*
    cp -r "$BRANCH" "$SURFACE"
    ln -sv "$SURFACE" "$SURFACE"-devel
    ln -sv "$SURFACE" "$SURFACE"-dbg
    # replace pkg names
    sed -i -n -e 's/"linux-stable-/"linux-stable-surface-/g' -e 's/pkgname = "linux-stable"/pkgname = "linux-stable-surface"/g' "$SURFACE"/template.py
}

copy_patches() {
    if test -d /tmp/linux-surface; then
        rm -rf /tmp/linux-surface
    fi
    git clone --depth=1 https://github.com/linux-surface/linux-surface /tmp/linux-surface

    for f in /tmp/linux-surface/patches/$VER/*; do
        # If patches are failing due to being adopted upstream or in Chimera, exclude here i.e.:
        # if ! echo "surface-sam.patch" | grep -q "$f"; then
        cp $f "$CPORTS_PATH/main/$SURFACE/patches/surface-$(basename $f)"
        # fi
    done

    echo "Patches applied. Building."
}

build_linux_surface() {
    cd "$CPORTS_PATH" || exit 1
    ./cbuild pkg "main/$SURFACE"
    git switch master
}

copy_linux
copy_patches
build_linux_surface
echo "
Build of main/$SURFACE completed.

If successful, run pkg-repo-sync.sh
"
