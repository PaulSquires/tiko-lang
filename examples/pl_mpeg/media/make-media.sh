#!/bin/bash
# examples/pl_mpeg/media: the clip the examples play -- two seconds of ffmpeg's test pattern at
# 320x240, 25 frames a second, MPEG-1, with a 440 Hz stereo tone as MP2 at 44.1 kHz, in an MPEG
# program stream -- generated, so its licence is ours. Made once with ffmpeg 4.4.2 (Ubuntu
# 22.04's); a different ffmpeg makes different bytes, and 01-info's checks would move.
# Arg: the output directory.
OUT=$1; mkdir -p "$OUT" && cd "$OUT" || exit 1
ffmpeg -hide_banner -loglevel error -y -bitexact \
    -f lavfi -i testsrc=size=320x240:rate=25:duration=2 \
    -f lavfi -i sine=frequency=440:sample_rate=44100:duration=2 \
    -ac 2 -c:v mpeg1video -q:v 4 -c:a mp2 -b:a 128k -format mpeg clip.mpg
sha256sum clip.mpg
