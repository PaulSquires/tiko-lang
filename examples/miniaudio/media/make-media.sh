#!/bin/bash
# examples/miniaudio/media: the sound files the examples play -- one second of a 440 Hz tone,
# stereo, 44.1 kHz, as WAV, FLAC, MP3 and Ogg Vorbis -- generated, so their licence is ours.
# Made once with ffmpeg 4.4.2 (Ubuntu 22.04's); a different ffmpeg makes different bytes, and
# 04-decode's numbers would move. Arg: the output directory.
OUT=$1; mkdir -p "$OUT" && cd "$OUT" || exit 1
F="ffmpeg -hide_banner -loglevel error -y -bitexact"
TONE="-f lavfi -i sine=frequency=440:sample_rate=44100:duration=1"
$F $TONE -ac 2 -c:a pcm_s16le tone.wav
$F $TONE -ac 2 -c:a flac tone.flac
$F $TONE -ac 2 -c:a libmp3lame -b:a 128k tone.mp3
$F $TONE -ac 2 -c:a libvorbis -q:a 4 tone.ogg
sha256sum tone.*
