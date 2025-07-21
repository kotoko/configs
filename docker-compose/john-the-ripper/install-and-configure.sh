#!/bin/bash

set -eo pipefail
set -x

# install john the ripper
export DEBIAN_FRONTEND="noninteractive"
apt update
apt upgrade -y
apt install -y vim john

# cleanup
apt-get clean
rm -rf /var/lib/apt/lists/*
