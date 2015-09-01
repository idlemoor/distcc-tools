#!/bin/sh
[ -z "$DISTCC_HOSTS" ] && exec /usr/bin/clang++ -integrated-as -target %ARCH%-slackware-linux%SLKABI% "$@"
exec /usr/bin/distcc /usr/bin/clang++ -integrated-as -target %ARCH%-slackware-linux%SLKABI% "$@"
