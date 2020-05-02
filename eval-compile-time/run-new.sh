#!/bin/bash

ROOT=`dirname $0`
if [ `uname -m` == "x86_64" ]; then
  RUNNERS="$ROOT/wasm.baseline.x86 $ROOT/wasm.cranelift.x86 $ROOT/wasm.ion.x86"
  NAMES="Baseline (x86),Cranelift (x86), Ion (x86)"
elif [ `uname -m` == "aarch64" ]; then
  RUNNERS="$ROOT/wasm.baseline $ROOT/wasm.cranelift-newbe"
  NAMES="Baseline (AArch64),Cranelift (AArch64)"
else
  echo "Unsupported architecture: " `uname -m`
  exit 1
fi

echo "Bench,$NAMES"
for bench in ./asm2wasm_*.wasm; do
  times="$bench,"
  for runner in $RUNNERS; do
    time=`$runner $ROOT/compile.js $bench`
    if [ $? -ne 0 ]; then
      time="FAIL"
    fi
    times="$times$time,"
  done
  echo $times
done
