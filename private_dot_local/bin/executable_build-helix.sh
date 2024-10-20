#!/bin/sh
mkdir -p ~/src
cd ~/src
if [ ! -d helix ]; then
    git clone https://github.com/helix-editor/helix.git
fi
cd helix
git pull
RUSTFLAGS="-C target-feature=-crt-static" cargo install --path helix-term --locked
ln -Tsv ~/src/helix/runtime ~/.config/helix/runtime
