#!/bin/bash

# Go to the directory with the script.
user=$(whoami)
cd "/home/$user/.bin/psd/"

./profile-sync-daemon.sh unsync
