#!/bin/sh

# awesome-client '
# package.cpath = package.cpath .. "/home/kesse/src/pa/target/debug/?.so;"
# local ok, pa = pcall(require, "libpa")
#
# awesome.emit_signal("signal::hh", nil)
# '

P=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo $P
