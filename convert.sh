#!/bin/sh

if [ -z "$1" ] ; then
  echo "ERROR: No input file specified" 1>&2
  exit 1
fi

if ! [ -f "$1" ] ; then
  echo "ERROR: $1 does not exist" 1>&2
  exit 1
fi

IF=$(basename "$1")
OF=${IF%.*}
SCANTYPE=$(mediainfo --Inform=Video\;%ScanType% "$1")
HEIGHT=$(mediainfo --Inform=Video\;%Height% "$1")

if [ -z "$SCANTYPE" ] ; then
  if [ $(head -c 5m "$1" | ffprobe -show_frames - 2>&1 | grep -c interlaced_frame=0) != 0 ] ; then
    SCANTYPE="Progressive"
  fi
  if [ $(head -c 5m "$1" | ffprobe -show_frames - 2>&1 | grep -c interlaced_frame=1) != 0 ] ; then
    SCANTYPE="Interlaced"
  fi
fi

if [ -f "$OF.mp4" ] ; then
  if [ "$(realpath "$1")" = "$(realpath "$OF.mp4")" ] ; then
    #echo input and output are the same file
    OF=$OF.encoded
  fi
fi

#echo input filename is: $IF
#echo output filename is: $OF
#echo scan type is: $SCANTYPE
#echo height is: $HEIGHT

if [ "$HEIGHT" -gt "480" ] ; then
  if [ "$SCANTYPE" = "Interlaced" ] ; then
    #echo HD Interlaced
    ffmpeg -n -i "$1" -vf yadif=1 -c:v libx264 -crf 24 -preset medium -tune film -profile:v high -level 4.2 -aq-mode 2 -x264opts colormatrix=bt709 -c:a aac -q:a 1.4 -movflags +faststart -loglevel warning "$OF.mp4"
  fi
  if [ "$SCANTYPE" = "Progressive" ] ; then
    #echo HD Progressive
    ffmpeg -n -i "$1" -c:v libx264 -crf 24 -preset medium -tune film -profile:v high -level 4.2 -aq-mode 2 -x264opts colormatrix=bt709 -c:a aac -q:a 1.4 -movflags +faststart -loglevel warning "$OF.mp4"
  fi
else
  if [ "$SCANTYPE" = "Interlaced" ] ; then
    #echo SD Interlaced
    ffmpeg -n -i "$1" -vf yadif=1 -c:v libx264 -crf 22 -preset medium -tune film -profile:v high -level 4.2 -aq-mode 2 -x264opts colormatrix=smpte170m -c:a aac -q:a 1.4 -movflags +faststart -loglevel warning "$OF.mp4"
  fi
  if [ "$SCANTYPE" = "Progressive" ] ; then
    #echo SD Progressive
    ffmpeg -n -i "$1" -c:v libx264 -crf 22 -preset medium -tune film -profile:v high -level 4.2 -aq-mode 2 -x264opts colormatrix=smpte170m -c:a aac -q:a 1.4 -movflags +faststart -loglevel warning "$OF.mp4"
  fi
fi
