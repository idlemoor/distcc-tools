#!/bin/sh
[ -z "$DISTCC_HOSTS" ] && exec /usr/bin/%ARCH%-slackware-linux%SLKABI%-g++ "$@"
exec /usr/bin/distcc /usr/bin/%ARCH%-slackware-linux%SLKABI%-g++ "$@"