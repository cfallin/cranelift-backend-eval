#!/bin/bash

ROOT=`dirname $0`
VM_BASELINE="$ROOT/wasm.baseline.x86"
VM_CL="$ROOT/wasm.cranelift.x86"
VM_ION="$ROOT/wasm.ion.x86"
OUT=$1

if [ "x$OUT" = "x" ]; then
    echo "Usage: run.sh OUT.csv"
    exit 1
fi

run_time() {
    tmpfile=`mktemp`
    echo "Running: $@" >&2
    /usr/bin/time -f "%E" -o $tmpfile "$@" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "FAIL"
    else
        t=`cat $tmpfile`
        echo "Time: $t" >&2
        rm -f $tmpfile
        echo "$t"
    fi
}

run_time_5() {
    times=""
    for i in `seq 0 4`; do
        t=`run_time "$@"`
        times="$times$t,"
    done
    echo $times
}

five_commas=",,,,,"
echo "Bench,x86 Baseline Compile${five_commas}x86 Baseline Comp+Run${five_commas}x86 Cranelift Compile${five_commas}x86 Cranelift Comp+Run${five_commas}x86 Ion Compile${five_commas}x86 Comp+Run${five_commas}" > $OUT

for bench in asm2wasm_*.wasm; do
    bench=`basename $bench .wasm`
    mainjs_full="${bench}.js"
    mainjs_compile="${bench}_compile_only.js"

    base_compile=`run_time_5 $VM_BASELINE $mainjs_compile`
    base_full=`run_time_5 $VM_BASELINE $mainjs_full`
    cl_compile=`run_time_5 $VM_CL $mainjs_compile`
    cl_full=`run_time_5 $VM_CL $mainjs_full`
    ion_compile=`run_time_5 $VM_ION $mainjs_compile`
    ion_full=`run_time_5 $VM_ION $mainjs_full`

    echo "$bench,${base_compile}${base_full}${cl_compile}${cl_full}${ion_compile}${ion_full}" >> $OUT
done
