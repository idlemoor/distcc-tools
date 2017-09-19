#!/bin/sh
export LD_LIBRARY_PATH=%INSTLOC%/%ARCH%-slackware-linux/arm-slackware-linux-%GNUEABI%/lib
exec %INSTLOC%/bin/arm-slackware-linux-%GNUEABI%-g++ "$@"
