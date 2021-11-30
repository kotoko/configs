#!/bin/bash
# Show information about possible kernel update.

CURRENT_KV="$(readlink /usr/src/linux)"
LATEST_KV_LINE="$(eselect kernel list | tail -n 1)"
LATEST_KV="$(awk '{print $2}' <<< ${LATEST_KV_LINE})"
LATEST_KV_INDEX="$(cut -d '[' -f 2 <<< ${LATEST_KV_LINE} | cut -d ']' -f 1)"

if ! grep -q '*' <<< "${LATEST_KV_LINE}"; then
	echo "A kernel update to ${LATEST_KV} is available! (currently running: ${CURRENT_KV})"
else
	echo "Your kernel (${CURRENT_KV}) is the latest version available!"
fi
