#!/bin/bash
set -e

/usr/bin/xbps-install --yes -Su xbps
/usr/bin/xbps-install --yes -Su
/usr/bin/xbps-install --yes -Su
/usr/bin/vkpurge rm all
/usr/bin/xbps-remove --yes -Oo
# /sbin/fstrim --all
