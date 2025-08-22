#!/bin/sh
# reusble variables and functions for posix shells, no bashisms

OS=$(uname)
case $OS in
Linux)
  . /etc/os-release
  CPUTYPE=""
  if lscpu | grep "GenuineIntel" >/dev/null 2>&1; then
    CPUTYPE="intel"
  fi
  if lscpu | grep "AuthenticAMD" >/dev/null 2>&1; then
    CPUTYPE="amd"
  fi
  ;;
Darwin)
  ID="darwin"
  ;;
*)
  echo "Unknown operating system: $OS"
  exit 1
  ;;
esac

# which su util to use
DOAS=""
if type sudo >/dev/null 2>&1; then
  # opensuse, Darwin, etc
  DOAS=sudo
elif type doas >/dev/null 2>&1; then
  # chimera linux by default, others optionally
  DOAS=doas
fi
if [ -z "$DOAS" ]; then
  echo "No sudo or doas available"
fi

case $ID in
"darwin")
  ADDCMD="$DOAS port install"
  RMCMD="$DOAS port uninstall"
  if ! type fetch >/dev/null 2>&1; then
    $ADDCMD fetch
  fi
  FETCHER="fetch -o"
  ;;
"chimera")
  ADDCMD="$DOAS apk add"
  RMCMD="$DOAS apk del"
  FETCHER="fetch -o" # freebsd and chimera, others use wget
  ;;
"opensuse-tumbleweed")
  ADDCMD="$DOAS zypper install"
  RMCMD="$DOAS zypper rm"
  FETCHER="wget -O"
  ;;
"void")
  ADDCMD="$DOAS xbps-install -Su"
  RMCMD="$DOAS xbps-remote -ROo"
  FETCHER="wget -O"
  ;;
"aeon")
  ADDCMD="$DOAS transactional-update pkg install"
  RMCMD="echo not doing any removal on $ID"
  FETCHER="wget -O"
  ;;
*)
  echo "Unsupported distribution $ID"
  exit 1
  ;;
esac

ask() {
  # usage:
  # if ! ask "Proceed with configuration? " Y; then
  #     echo "aborting"
  # else
  #     echo "proceeding"
  # fi

  if [ "$2" = 'Y' ]; then
    prompt='Y/n'
    default='Y'
  elif [ "$2" = 'N' ]; then
    prompt='y/N'
    default='N'
  else
    prompt='y/n'
    default=''
  fi

  while true; do
    echo "$1 [$prompt] "
    read -r reply </dev/tty
    # Default?
    if [ -z "$reply" ]; then
      reply=$default
    fi
    case "$reply" in
    Y* | y*) return 0 ;;
    N* | n*) return 1 ;;
    esac
  done
}
