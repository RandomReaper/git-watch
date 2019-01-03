#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "this install script should be run as root (sudo)"
  exit 1
fi

type inotifywatch >/dev/null 2>&1 || { echo >&2 "Please install inotifywatch"; exit 1; }

cp -a git-watch.sh /usr/bin/
cp -a git-watch.service /usr/lib/systemd/system/
cp -a git-watch@.service /usr/lib/systemd/system/
mkdir -p /etc/git-watch
systemctl daemon-reload