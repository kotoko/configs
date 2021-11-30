#!/bin/bash
# Clean outdated source tarballs from PKGDIR in Gentoo.
set -e
eclean --deep distfiles
