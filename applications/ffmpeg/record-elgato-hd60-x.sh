#!/bin/bash
set -eu

RESOLUTION='1920x1080'
FPS='60'

# Parse parameters
if [ "$#" -gt '1' ]; then
	echo 'Expected one parameter - output file name! Aborting...' >&2
	exit 1
fi
if [ "$#" -eq '0' ]; then
	RECORDING_FILE='recording'
fi
if [ "$#" -eq '1' ]; then
	RECORDING_FILE="$1"
fi
if [ ! "${RECORDING_FILE##*.}" = "mkv" ]; then
	RECORDING_FILE="${RECORDING_FILE}.mkv"
fi
if [ -e "${RECORDING_FILE}" ]; then
	echo "Destination file '${RECORDING_FILE}' already exists! Aborting..." >&2
	exit 1
fi

# Find elgato video
DEV_VIDEO="$(v4l2-ctl --list-devices | grep --after-context=3 'Elgato HD60 X:' | head -n2 | tail -n1 | tr -d '[:space:]')"
if [ "${DEV_VIDEO}" = '' ] || [ ! -e "${DEV_VIDEO}" ]; then
	echo "Could not detect elgato video device (DEV_VIDEO='${DEV_VIDEO}')! Aborting..." >&2
	exit 1
fi

# Find elgato audio
DEV_AUDIO="$(arecord -l | grep 'Elgato HD60 X' | head -n1 | sed -E 's#^card ([0-9]+):.*device ([0-9]+):.*$#hw:\1,\2#')"
if [ "${DEV_AUDIO}" = '' ]; then
	echo "Could not detect elgato audio device (DEV_AUDIO='${DEV_AUDIO}')! Aborting..." >&2
	exit 1
fi

# Set YUV parameters
FFMPEG_YUV='yuv422p'
GSTREAMER_YUV='YUY2'

# Set capture parameters
WIDTH="$(echo -n "${RESOLUTION}" | cut -d 'x' -f 1)"
HEIGHT="$(echo -n "${RESOLUTION}" | cut -d 'x' -f 2)"
VIDEO_CAPABILITIES="video/x-raw, format=(string)${GSTREAMER_YUV}, width=(int)${WIDTH}, height=(int)${HEIGHT}, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ ${FPS}/1 }"
AUDIO_CAPABILITIES="audio/x-raw, format=(string)S16LE, rate=(int)48000, channels=(int)2"

# Capture video + audio
ffmpeg -i <(
    gst-launch-1.0 -q \
        v4l2src device="${DEV_VIDEO}" do-timestamp=true ! ${VIDEO_CAPABILITIES} ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 ! mux. \
        alsasrc device="${DEV_AUDIO}" do-timestamp=true ! ${AUDIO_CAPABILITIES} ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 ! mux. \
        matroskamux name=mux ! queue max-size-buffers=0 max-size-time=0 max-size-bytes=0 ! fdsink fd=1
    ) \
    -c:v libx264 -vf scale=in_range=full:out_range=full -tune "film" -preset "ultrafast" -crf "8" -pix_fmt "${FFMPEG_YUV}" \
    -c:a copy \
    "${RECORDING_FILE}"



##### Elgato hd60 x formats

#$ gst-launch-1.0 --gst-debug=v4l2src:5 v4l2src device=/dev/video1 ! fakesink 2>&1 | sed -une '/caps of src/ s/[:;] /\n/gp'
# video/x-raw, format=(string)YUY2, width=(int)1920, height=(int)1080, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)YUY2, width=(int)1600, height=(int)1200, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)YUY2, width=(int)1280, height=(int)720, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)YUY2, width=(int)720, height=(int)576, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)YUY2, width=(int)720, height=(int)480, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)YUY2, width=(int)640, height=(int)480, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)3840, height=(int)2160, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)2560, height=(int)1440, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)1920, height=(int)1080, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 120/1, 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)1600, height=(int)1200, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)1280, height=(int)720, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)720, height=(int)576, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)720, height=(int)480, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }
# video/x-raw, format=(string)NV12, width=(int)640, height=(int)480, pixel-aspect-ratio=(fraction)1/1, framerate=(fraction){ 60/1, 50/1, 30/1, 25/1 }

#$ gst-launch-1.0 --gst-debug=alsa:5 alsasrc device=hw:1,0 ! fakesink 2>&1 | sed -une '/returning caps/  s/[s;] /\n/gp'
# audio/x-raw, format=(string)S16LE, layout=(string)interleaved, rate=(int)48000, channels=(int)2, channel-mask=(bitmask)0x0000000000000003
