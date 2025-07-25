#!/bin/bash

# optional arg0 = restart | no-restart
# default = "restart"
ARG_SHOULD_KILL_XCODE=${1:-restart}

if [ "$ARG_SHOULD_KILL_XCODE" == "restart" ]; then
  SHOULD_KILL_XCODE=1

elif [ "$ARG_SHOULD_KILL_XCODE" == "no-restart" ]; then
  SHOULD_KILL_XCODE=0

else
  echo "Invalid argument: $ARG_SHOULD_KILL_XCODE"
  echo "Usage: $0 [restart | no-restart]"
  exit 1
fi

if [ "$SHOULD_KILL_XCODE" -eq 1 ]; then
  killall Xcode 2>/dev/null
fi

export $(grep -v '^#' .env | xargs) ; open ./Example/*.xcodeproj