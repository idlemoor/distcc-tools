#!/bin/bash
declare -a arglist
for arg in "$@"; do
  [ "$arg" != '-m64' ] && arglist+=( "$arg" )
done
export LD_LIBRARY_PATH=%GCCLOC%/lib%LIBDIRSUFFIX%
exec %GCCLOC%/bin/%COMPILER% -m32 "${arglist[@]}"
