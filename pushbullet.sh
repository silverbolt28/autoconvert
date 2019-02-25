#!/bin/sh

TITLE="$1"
MSG="$2"

if [ -z "$PBTOKEN" ] ; then
  echo "PBTOKEN variable not set" 1>&2
  exit 1
else
  curl -sS -u $PBTOKEN: https://api.pushbullet.com/v2/pushes -d type=note -d title="$TITLE" -d body="$MSG"
fi
