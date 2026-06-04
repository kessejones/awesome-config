#!/usr/bin/env bash

if pgrep -x --full "pactl subscribe" >/dev/null; then
    pkill -TERM -x pactl
    sleep 0.5
fi

pactl subscribe 2> /dev/null | grep --line-buffered "Event 'change' on sink #" | awk '{print 1}'
