#!/bin/sh
if [ "$1" == 'distcc' ] || [ "$1" == '/usr/bin/distcc' ] || [ "$1" == 'ccache' ] || [ "$1" == '/usr/bin/ccache' ]; then
  shift
else
  case "$1" in
    -*) exec /usr/bin/"$(basename "$0")" "$@" ;;
     *) : ;;
  esac
fi
exec "$@"
