#!/bin/sh

set -e
set -x

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "USAGE: docker run youtube-to-karaoke YOUTUBE_URL OUTPUT_FILE"
    exit 1
fi

# Download video and audio with youtube-dl
cd /src/youtube-dl/
python3 -m youtube_dl -f 'bestvideo[ext=mp4]' $1 -o /tmp/raw_video.mp4
python3 -m youtube_dl -f 'bestaudio[ext=m4a]' $1 -o /tmp/raw_audio.m4a

# Create instrument-only audio with remove-vocal
cd /src/vocal-remover/
python3 inference.py --input /tmp/raw_audio.m4a
mv ./raw_audio_Instruments.wav /tmp/instrument_track.wav

# Bundle output video with ffmpeg
ffmpeg -i /tmp/raw_video.mp4 \
    -i /tmp/raw_audio.m4a \
    -i /tmp/instrument_track.wav \
    -c:v copy -c:a aac \
    -map 0:v:0 -map 1:a:0 -map 2:a:0 \
    $2
