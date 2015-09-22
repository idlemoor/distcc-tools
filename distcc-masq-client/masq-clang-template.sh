#!/bin/sh
[ -z "$DISTCC_HOSTS" ] && exec /usr/bin/%COMPILER% -integrated-as -target %ARCH%-slackware-linux%SLKABI% "$@"
exec /usr/bin/distcc /usr/bin/%COMPILER% -integrated-as -target %ARCH%-slackware-linux%SLKABI% "$@"
