#!/bin/sh
# Update remote repo using rsync

CPORTS_PATH="$HOME/cports"
KEY_PATH="$CPORTS_PATH/etc/keys/git@mikewatkins.ca-6721c768.rsa.pub"
REPO="bugs:/home/mox/web/chimera.solutionroute.com/"

if ! test -d "$CPORTS_PATH"; then
    echo "$CPORTS_PATH does not exist, have you cloned it and built something?"
    exit 1
fi

# clear out any previously built obsolete or removed pkgs
cd "$CPORTS_PATH" || exit 1
./cbuild prune-pkgs
./cbuild index

cd "$CPORTS_PATH/packages" || exit
# if this fails, stop
cp $KEY_PATH . || exit
echo "
# Chimera Linux - custom packages

A small collection of packages that do not make sense to submit to the Chimera
Linux project.

These may include:

- Patched Linux kernel for Microsoft Surface devices
- Others

## Installing

- These are signed packages. Copy the public key to your system's /etc/apk/keys/
- Create a respository in /etc/apk/repositories.d/ pointing to this
  location, and pin the repo, i.e.:

  02-solutionroute-main.list:

    @cports https://chimera.solutionroute.com/main/

Then you can install packages from this pinned repo and they will 
take precedence over like-named packages in the standard Chimera 
repos, i.e.:

    apk add linux-stable-surface@cports    

*README.md is updated by pkg-repo-sync.sh*
" | tee README.md

echo "Syncronizing package directories with public server"
rsync -av --delete --update main $REPO
rsync -av --delete --update user $REPO
scp $KEY_PATH README.md $REPO
