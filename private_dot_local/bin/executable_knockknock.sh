#!/bin/sh
KNOCKR="$HOME/go/bin/knockr"
if [ ! -x "$KNOCKR" ]; then
	go install github.com/mwyvr/knockr@latest
fi
# port knock router to open wireguard
. ~/.knock.env
$KNOCKR $KNOCKARGS
$KNOCKR $TESTARGS
