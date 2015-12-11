#!/bin/sh
if [ "$1" == 'distcc' ] || [ "$1" == '/usr/bin/distcc' ] || [ "$1" == 'ccache' ] || [ "$1" == '/usr/bin/ccache' ]; then shift; fi
exec "$@"
