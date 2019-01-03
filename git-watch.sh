#!/bin/bash
if [ -z "${1+x}" ]; then
	echo "no args, exiting"
	exit 1
fi

CONFIGURATION_DIRECTORY=${CONFIGURATION_DIRECTORY:=$PWD}
CACHE_DIRECTORY=${CACHE_DIRECTORY:=/var/cache/git-watch}

NAME=$1
CFG="$CONFIGURATION_DIRECTORY"/"$NAME"
CLONEDIR="$CACHE_DIRECTORY"/"$NAME"/git

if [ ! -f "$CFG" ]; then
    echo "Configuration file '$CFG' not found, exiting"
    exit 1
fi

source "$CFG"

if [ -z "${GITSRC+x}" ]; then
	echo "GITSRC is not set, exiting"
	exit 1
fi

if [ ! -d "$GITSRC" ]; then
	echo "GITSRC is not a directory, exiting"
	exit 1
fi

if [ -z "${GITCMD+x}" ]; then
	echo "GITCMD is not set, exiting"
	exit 1
fi

mkdir -p "$CACHE_DIRECTORY"/"$NAME" || exit 1


while true
do
	if [ ! -d "$CLONEDIR" ]; then
		git clone "$GITSRC" "$CLONEDIR" || exit 1
	else
		cd "$CLONEDIR" || exit 1
		git fetch --all || exit 1
		git reset --hard origin/master || exit 1
	fi

	cd "$CLONEDIR" || exit 1
	git log -n1 "$CLONEDIR"
	OUT=$(mktemp -t "git-watch-$NAME-out.XXXXXX")
	ERR=$(mktemp -t "git-watch-$NAME-err.XXXXXX")
	if $GITCMD >"$OUT" 2>"$ERR" ; then
		echo success
		echo STDOUT:
		cat "$OUT"
		echo ---
		echo STDERR:
		cat "$ERR"
		echo ---
	else
		echo error
		echo STDOUT:
		cat "$OUT"
		echo ---
		echo STDERR:
		cat "$ERR"
		echo ---
	fi
	rm -f "$OUT" "$ERR"

	inotifywait "$GITSRC"/.git/refs/heads/master
done