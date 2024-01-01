#!/bin/sh
#
# This file is sourced at Plasma startup, so that
# the environment variables set here are available
# throughout the session.

if [ -x /usr/bin/gpgconf ]; then
    /usr/bin/gpgconf --launch gpg-agent >/dev/null 2>&1
fi

if [ -x /usr/bin/ssh-agent ]; then
  eval "$(/usr/bin/ssh-agent -s)"
fi

