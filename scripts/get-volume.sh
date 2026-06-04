#!/bin/sh

SINK=$(pactl get-default-sink)
pactl get-sink-volume $SINK | head -n1 | cut -d"/" -f2 | sed 's/[^0-9]//g'
