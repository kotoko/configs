#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &>/dev/null && pwd )
cd "$SCRIPT_DIR"

# check if container is running
docker inspect zeek-live-traffic | jq | grep -i 'status' | grep -q 'running'
RC="$?"

# should restart container?
CONTAINER="0"
if [ "$RC" -eq 0 ]; then
	CONTAINER="1"
fi

# stop container
if [ "$CONTAINER" -eq 1 ]; then
	docker compose down
fi

# rotate logs
mkdir -p ./data/logs-old
logrotate ./logrotate.conf --force

# start container
if [ "$CONTAINER" -eq 1 ]; then
	docker compose up -d
fi
