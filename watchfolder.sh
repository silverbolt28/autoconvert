#!/bin/sh

if ! [ -f /config/convert.sh ] ; then
  umask 000
  cp /bin/convert.sh /config/convert.sh
fi

umask 111
cd /data/encoded

while true ; do
  for f in /data/watch/* ; do
    if [ "$f" = "/data/watch/*" ] ; then
      break
    fi
    nice -n 19 /config/convert.sh "$f"
    mv "$f" /data/completed/
    filename=$(basename "$f")
    /bin/pushbullet.sh "AutoConvert" "Finished converting $filename"
  done
  sleep 60
done
