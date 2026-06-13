#!/bin/sh

if pgrep -x pa_bin >/dev/null; then
    exit 0
fi

DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$DIR/result/bin/pa_bin
