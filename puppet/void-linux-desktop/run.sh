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
	xbps-install --yes -S
	touch "/tmp/repo_updated"
fi

# Install ruby if neccessary.
if ! command -v ruby >/dev/null 2>&1; then
	xbps-install --yes ruby
fi

# Install puppet if neccessary.
GEM_BIN_PATH=`(gem env | grep 'USER INSTALLATION DIRECTORY' | sed --quiet "s/.*USER INSTALLATION DIRECTORY: \(.*\)/\1/p")`"/bin"
export PATH="$GEM_BIN_PATH:$PATH"
if ! command -v puppet >/dev/null 2>&1; then
	gem install --user-install puppet
fi

# Remove temporary repository.
if [ -f "/etc/xbps.d/tmp-repository.conf" ]; then
	rm -f "/etc/xbps.d/tmp-repository.conf"
fi

# Apply puppet configuration.
puppet apply --modulepath ./modules manifests/init.pp

# Remove puppet.
yes y | gem uninstall puppet
rm -rf /root/.local/share/gem

# Remove ruby.
xbps-remove --yes ruby
xbps-remove --yes -Oo

echo
echo "All done! You can reboot now."
