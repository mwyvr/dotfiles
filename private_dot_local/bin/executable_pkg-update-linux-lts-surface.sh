#!/bin/sh
# update our local linux-lts-surface branch with the latest patches
# from the linux-surface project. https://github.com/linux-surface/linux-surface

CPORTS_PATH="$HOME/cports"
VER="6.6"

if ! test -d "$CPORTS_PATH"; then
    echo "$CPORTS_PATH does not exist, have you cloned it?"
    exit 1
else
    cd $CPORTS_PATH
    if ! git switch linux-lts-surface; then
        echo "Can't switch to linux-lts-surface branch"
        exit 1
    fi
fi

if test -d /tmp/linux-surface; then
    rm -rf /tmp/linux-surface
fi
git clone --depth=1 https://github.com/linux-surface/linux-surface /tmp/linux-surface
for f in /tmp/linux-surface/patches/$VER/*; do
    # already implemented in base config
    if ! echo "surface-sam.patch" | grep -q "$f"; then
        cp $f "$CPORTS_PATH/main/linux-lts-surface/patches/surface-$(basename $f)"
    fi
done

echo "Patches applied. 
Build with ./cbuild pkg main/linux-lts-surface.
Then run pkg-repo-sync.sh"
