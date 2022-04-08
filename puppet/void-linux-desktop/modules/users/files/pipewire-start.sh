#!/bin/sh

DUALBOOT="$(/usr/bin/grep '^ID=' /etc/os-release | /usr/bin/sed -e 's/\(ID=\)\(.*\)/\2/g' | /usr/bin/tr -d \"\' )"
if [ "$DUALBOOT" = "void" ]; then
	mkdir -p "/tmp/$(/usr/bin/id -un)/pipewire-autostart"
	cd "/tmp/$(/usr/bin/id -un)/pipewire-autostart" || exit 1

	/usr/bin/nohup /usr/bin/pipewire &
	/usr/bin/nohup /usr/bin/pipewire-pulse &
fi
