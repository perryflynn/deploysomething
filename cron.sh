#!/bin/bash

# Change into letsencrypt dir
BASE="$(dirname "$0")"
cd "$BASE"

# Config
if [ ! -f config ]; then
    echo "Config file not found!"
    exit 1
fi

. config

# Test server connection
function testserver() {
    if [ "$(curl -I -sSf --connect-timeout 1 --max-time 2 "$1" | head -n 1 | awk '{print $2}' 2> /dev/null)" == "200" ]; then
        return 0
    else
        return 1
    fi
}

# Test connection to deployment server
if ! testserver "$LESRV"; then
    echo "Deployment server $LESRV is not available. Abort."
    exit 1
fi

# Get certificates
for S in $SRCD/*; do

    NAME=$(basename "$S")

    if ! [[ $NAME =~ ^\..+ ]]; then
        NAMEDIR="cert-$NAME"
        TOKEN=$(cat "$S" | tr -d '[:space:]')

        if [ -d "$NAMEDIR" ]; then
            rm -rf "$NAMEDIR"
        fi

        echo "--> $NAMEDIR"
        mkdir "$NAMEDIR"

        wget --quiet -r -nH -nd -np "$LESRV/$TOKEN/" -P "$NAMEDIR"
        chmod u=rw,go=- -R "$NAMEDIR"/*

        ls -lisahF "$NAMEDIR"
        echo

    fi

done

# Post download hooks
for S in $HOOKD/*; do
    if [ -x "$S" ] && ! [[ $S =~ ^\..+ ]]; then
        echo "--> Hook $S"
        $S "$BASE"
        echo
    fi
done

echo "Done."

