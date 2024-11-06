#!/bin/sh
# Update remote repo using rsync

CPORTS_PATH="$HOME/cports"
KEY_PATH="$CPORTS_PATH/etc/keys/git@mikewatkins.ca-6721c768.rsa.pub"
REPO="bugs:/home/mox/web/chimera.solutionroute.com/."

if ! test -d "$CPORTS_PATH"; then
    echo "$CPORTS_PATH does not exist, have you cloned it?"
    exit 1
fi
cd "$CPORTS_PATH/packages"

echo "Syncronizing package directory with public server"
scp $KEY_PATH $REPO
rsync -aAXv main $REPO
