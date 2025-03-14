#!/bin/bash

# https://aur.archlinux.org/packages/networkmanager-dispatcher-chrony#comment-976089

INTERFACE=$1
STATUS=$2

# Make sure we're always getting the standard response strings
LANG='C'

CHRONY='/usr/bin/chronyc'

chrony_cmd() {
  echo "Chrony going $1."
  exec $CHRONY -a $1
}

nm_connected() {
  # Let networkmanager check if we are able to reach the internet
  [ "$(nmcli networking connectivity check)" = 'full' ]
}

case "$STATUS" in
  up|vpn-up)
    if [ "$INTERFACE" != "lo" ]; then
      # Check for full connectivity, take online if connected
      nm_connected && chrony_cmd online
    fi
  ;;
  down|vpn-down)
    if [ "$INTERFACE" != "lo" ]; then
      # Check for full connectivity, take offline if not connected
      nm_connected || chrony_cmd offline
    fi
  ;;
esac
