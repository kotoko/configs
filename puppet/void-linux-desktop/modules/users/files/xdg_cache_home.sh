#!/bin/bash

U=`whoami`
if [ "$U" != "root" ]; then
  mkdir -p "/tmp/${U}"
  export XDG_CACHE_HOME="/tmp/${U}/.cache"
fi
