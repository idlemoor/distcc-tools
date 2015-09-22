#!/bin/sh
[ -z "$DISTCC_HOSTS" ] && exec /usr/bin/%ARCH%-slackware-linux%SLKABI%-%COMPILER% "$@"
exec /usr/bin/distcc /usr/bin/%ARCH%-slackware-linux%SLKABI%-%COMPILER%-%GCCVERSION% "$@"
