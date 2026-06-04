#!/bin/sh

if pgrep --full "audio-listener.lua" >/dev/null; then
    pkill -TERM --full "audio-listener.lua"
    sleep 0.5
fi

lua $HOME/.config/awesome/scripts/audio-listener.lua
