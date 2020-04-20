#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: make-stub wrapper.js"
    exit 1
fi

INPUT=$1
OUTPUT=`basename $1 .js`_compile_only.js

#cat $INPUT | sed -e 's/asm._main/asm.__doNotRun/g' > $OUTPUT

# the call to the Wasm's _main function is always of the form
# "x.asm._main.apply(null,arguments)", where x is some arbitrary
# variable name. We substitute everything but the first variable
# with "& 0", which always evaluates to zero (the first arg, x, is
# coerced to an int32), i.e. a successful return from main().
cat $INPUT | sed -e 's/.asm._main.apply(null,arguments)/\&0/g' > $OUTPUT
