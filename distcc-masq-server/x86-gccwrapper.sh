#!/bin/bash
declare -a arglist
for arg in "\$@"; do
  [ "\$arg" != '-m64' ] && arglist+=( "\$arg" )
done
exec x86_64-slackware-linux-gcc -m32 "\${arglist[@]}"
