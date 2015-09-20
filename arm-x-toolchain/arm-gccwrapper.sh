#!/bin/sh
export LD_LIBRARY_PATH=%INSTLOC%/%ARCH%-slackware-linux/arm-slackware-linux-gnueabi/lib
exec %INSTLOC%/bin/arm-slackware-linux-gnueabi-gcc "$@"
