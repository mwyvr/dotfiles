#!/bin/sh
mkdir -p ~/src
cd ~/src
if [ ! -d helix ]; then
    git clone https://github.com/helix-editor/helix.git
fi
cd helix
RUSTFLAGS="-C target-feature=-crt-static" cargo install --path helix-term --locked
