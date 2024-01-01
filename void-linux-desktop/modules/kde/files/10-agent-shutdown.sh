#!/bin/sh
#
# This file is executed at Plasma shutdown.

if [ -x /usr/bin/gpgconf ]; then
    /usr/bin/gpgconf --kill gpg-agent >/dev/null 2>&1
fi

if [ -n "${SSH_AGENT_PID}" ]; then
    eval "$(/usr/bin/ssh-agent -s -k)"
fi
