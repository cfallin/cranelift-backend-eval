#!/bin/sh

VALGRIND="./valgrind"
JS="./js"
COMPS="baseline cranelift"
if [ `uname -m` == "x86_64" ]; then
  COMPS="$COMPS ion"
fi

for fff in asm2wasm_*.js; do
    echo $fff | grep -q _compile_only
    if [ $? -eq 0 ]; then continue; fi

    echo
    echo ============================================
    for comp in $COMPS; do
        echo
        echo == ${comp} == ${fff} ==
        rm -f cachegrind.out.xx
        QRUST_LOG=info RAYON_NUM_THREADS=1 \
            $VALGRIND --tool=cachegrind --vex-guest-chase=no \
            --cache-sim=no \
            --cachegrind-out-file=cachegrind.out.xx \
            $JS \
            --no-threads --no-wasm-multi-value --shared-memory=off \
            --wasm-compiler=${comp} ${fff} > /dev/null 2> /dev/null
        cg_annotate --show=Ir cachegrind.out.xx | egrep "PROGRAM\ TOTALS|\?\?\?:\?\?\?"
    done
done
