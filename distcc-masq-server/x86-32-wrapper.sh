#!/bin/bash
declare -a arglist
for arg in "$@"; do
  [ "$arg" != '-m64' ] && arglist+=( "$arg" )
done
exec /usr/bin/x86_64-slackware-linux-%COMPILER% -m32 "${arglist[@]}"
