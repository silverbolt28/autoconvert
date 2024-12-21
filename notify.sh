#!/bin/sh

TITLE="$1"
MSG="$2"

if [ -z "$PBTOKEN" ] ; then
  echo "PBTOKEN variable not set, skipping Pushbullet" 1>&2
else
  curl -sS -u $PBTOKEN: https://api.pushbullet.com/v2/pushes -d type=note -d title="$TITLE" -d body="$MSG"
fi

if [ -z "$DISCORDWEBHOOK" ] ; then
  echo "DISCORDWEBHOOK variable not set, skipping Discord" 1>&2
else
  curl -H "Content-Type: application/json" -d '{"username": '\"$1\"', "content": '\"$2\"'}' "$DISCORDWEBHOOK"
fi
