#!/bin/bash
# Clean outdated binary packages in Gentoo.
set -e
eclean --deep packages
