#!/usr/bin/env -S bash -e

cd "$(dirname "${BASH_SOURCE:-$0}")/.."

if [[ $# -gt 0 ]]; then
  shift
  ARGS="OPT=\"$@\""
fi

eval "make clean && make -j $ARGS"
mv stockfishWeb.wasm stockfishWeb.60.wasm

git checkout smollnet-16ish

eval "make clean && make -j $ARGS"
mv stockfishWeb.wasm stockfishWeb.7.wasm

git checkout sf-16

eval "make clean && make -j $ARGS"

git checkout master
