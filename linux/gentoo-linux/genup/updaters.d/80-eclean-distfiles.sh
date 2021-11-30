#!/bin/bash
# Clean outdated source tarballs in Gentoo.
set -e
eclean --deep distfiles
