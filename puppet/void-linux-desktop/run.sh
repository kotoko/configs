#!/bin/bash
set -e

# Go to the directory with the script.
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd "${SCRIPTPATH}"

# Make sure I am root.
if [ "$(whoami)" != "root" ]; then
	echo "ERROR: Script must be run as root!" >&2
	exit 1
fi

# Set temporary repository.
if [ ! -f "/tmp/repo_updated" ]; then
	echo "repository=https://mirrors.dotsrc.org/voidlinux/current" > "/etc/xbps.d/tmp-repository.conf"
	yes y | xbps-install -S
	touch "/tmp/repo_updated"
fi

# Install puppet if neccessary.
if ! command -v puppet >/dev/null 2>&1; then
	yes y | xbps-install puppet
fi

# Remove temporary repository.
if [ -f "/etc/xbps.d/tmp-repository.conf" ]; then
	rm -f "/etc/xbps.d/tmp-repository.conf"
fi

# Apply puppet configuration.
puppet apply --modulepath ./modules manifests/init.pp

# Remove puppet.
yes y | xbps-remove puppet
yes y | xbps-remove -Oo

echo
echo "All done! You can reboot now."
