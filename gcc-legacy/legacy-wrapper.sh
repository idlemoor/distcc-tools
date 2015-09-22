#!/bin/sh
export LD_LIBRARY_PATH=%GCCLOC%/lib%LIBDIRSUFFIX%
exec %GCCLOC%/bin/%COMPILER% "$@"
