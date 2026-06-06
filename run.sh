#!/bin/sh

Xephyr :1 -screen 1280x800 &
DISPLAY=:1 awesome
