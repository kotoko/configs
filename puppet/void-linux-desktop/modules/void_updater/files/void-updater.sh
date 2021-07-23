#!/bin/bash
set -e

yes y | /usr/bin/xbps-install -Su xbps
yes y | /usr/bin/xbps-install -Su
yes y | /usr/bin/xbps-install -Su
/usr/bin/vkpurge rm all
yes y | /usr/bin/xbps-remove -Oo
# /sbin/fstrim --all
