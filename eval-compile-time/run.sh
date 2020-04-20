#!/bin/bash

CLIFUTIL=$HOME/wasmtime.trunk/target/release/clif-util
JS=`dirname $0`/../js.mainline
WRAPPER=`dirname $0`/compile.js

export RAYON_NUM_THREADS=1

for file in asm2wasm_*.wasm; do
  echo
  echo ============================================

  echo == cl-x86 == ${file} ==
  for i in `seq 0 4`; do
    /usr/bin/time -f "%e" -o tmp.out $CLIFUTIL wasm -T --target x86_64 $file >/dev/null 2>&1
    cat tmp.out
    rm -f tmp.out
  done

  echo == cl-aarch64 == ${file} ==
  for i in `seq 0 4`; do
    /usr/bin/time -f "%e" -o tmp.out $CLIFUTIL wasm -T --target aarch64 $file >/dev/null 2>&1
    cat tmp.out
    rm -f tmp.out
  done

  echo == js-baseline-x86 == ${file} ==
  for i in `seq 0 4`; do
    $JS --no-threads --no-wasm-multi-value --shared-memory=off --wasm-compiler=baseline --ion-offthread-compile=off $WRAPPER $file #>/dev/null 2>&1
  done

  echo == js-cl-x86 == ${file} ==
  for i in `seq 0 4`; do
    $JS --no-threads --no-wasm-multi-value --shared-memory=off --wasm-compiler=cranelift --ion-offthread-compile=off $WRAPPER $file #>/dev/null 2>&1
  done

  echo == js-ion-x86 == ${file} ==
  for i in `seq 0 4`; do
    $JS --no-threads --no-wasm-multi-value --shared-memory=off --wasm-compiler=ion --ion-offthread-compile=off $WRAPPER $file #>/dev/null 2>&1
  done

done
