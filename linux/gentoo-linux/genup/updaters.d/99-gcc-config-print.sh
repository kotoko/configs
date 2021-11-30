#!/bin/bash
# Show selected GCC profile.
set -e
echo "Available GCC profiles:"
gcc-config --list-profiles
