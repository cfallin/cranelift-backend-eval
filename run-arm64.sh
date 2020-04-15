#!/bin/bash

ROOT=`dirname $0`
VM_BASELINE="$ROOT/wasm.baseline"
VM_CL="$ROOT/wasm.cranelift-newbe"
OUT=$1

if [ "x$OUT" = "x" ]; then
    echo "Usage: run.sh OUT.csv"
    exit 1
fi

run_time() {
    tmpfile=`mktemp`
    echo "Running: $@" >&2
    /usr/bin/time -f "%E" -o $tmpfile "$@"
    if [ $? -ne 0 ]; then
        echo "FAIL"
    else
        t=`cat $tmpfile`
        echo "Time: $t" >&2
        rm -f $tmpfile
        echo "$t"
    fi
}

run_time_10() {
    times=""
    for i in `seq 0 9`; do
        t=`run_time "$@"`
        times="$times$t,"
    done
    echo $times
}

ten_commas=",,,,,,,,,,"
echo "Bench,ARM64 Baseline Compile${ten_commas}ARM64 Baseline Comp+Run${ten_commas}ARM64 Cranelift Compile${ten_commas}ARM64 Cranelift Comp+Run${ten_commas}" > $OUT

for bench in asm2wasm_*.wasm; do
    bench=`basename $bench .wasm`
    mainjs_full="${bench}.js"
    mainjs_compile="${bench}_compile_only.js"

    base_compile=`run_time $VM_BASELINE $mainjs_compile`
    base_full=`run_time $VM_BASELINE $mainjs_full`
    cl_compile=`run_time $VM_CL $mainjs_compile`
    cl_full=`run_time $VM_CL $mainjs_full`

    echo "$bench,${base_compile}${base_full}${cl_compile}${cl_full}" >> $OUT
done
