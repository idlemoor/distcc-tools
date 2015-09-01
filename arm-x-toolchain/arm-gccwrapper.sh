#!/bin/sh
export LD_LIBRARY_PATH=/opt/%PRGNAM%/%ARCH%-slackware-linux/arm-slackware-linux-gnueabi/lib
exec %ARCH%-slackware-linux-gcc "$@"
