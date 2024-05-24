#!/bin/bash
if [ "$HOSTNAME" = "elron" ]; then
	echo "Do not backup on to yourself"
	exit 1
else
	echo "Backing up elron to $HOSTNAME"
	cd ~
	rsync -av elron:Documents .
	rsync -av elron:Pictures .
	rsync -av elron:Projects .
fi
