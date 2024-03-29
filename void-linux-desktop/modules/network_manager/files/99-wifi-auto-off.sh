#!/bin/bash

# https://superuser.com/a/367472

wired_interfaces="en.*|eth.*"
if [[ "$1" =~ $wired_interfaces ]]; then
	case "$2" in
		up)
			nmcli radio wifi off
			;;
		down)
			nmcli radio wifi on
			;;
	esac
fi
