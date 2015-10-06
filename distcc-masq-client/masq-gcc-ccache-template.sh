#!/bin/sh
[ -z "$DISTCC_HOSTS" ] && export CCACHE_PREFIX=''
exec /usr/bin/ccache /usr/bin/%ARCH%-slackware-linux%SLKABI%-%COMPILER%-%GCCVERSION% "$@"
