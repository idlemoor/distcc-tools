#!/bin/sh
[ -z "$DISTCC_HOSTS" ] && export CCACHE_PREFIX=''
exec /usr/bin/ccache /usr/bin/%COMPILER% -integrated-as -target %ARCH%-slackware-linux%SLKABI% "$@"
