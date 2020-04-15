Evaluation steps
----------------

1. Build a local SpiderMonkey JS shell with our Cranelift branch. See
   build-spidermonkey-cranelift.txt for details.

   - Place this binary in this directory as `js.x86` or `js.arm64`.

2. Check out embenchen: https://github.com/kripken/embenchen

   - We'll be using the Wasm tests in embenchen/asm\_v\_wasm.

3. Create "compile-only" versions of the toplevel .js programs:

    # assuming $THIS_REPO is the path to this repo:

    $ cd embenchen/asm_v_wasm
    $ for x in asm2wasm_*.js; do $THIS_REPO/make_compile_only.sh $x; done

4. Run evaluations:

    # on ARM64 machine:

    $ cd embenchen/asm_v_wasm
    $ $THIS_REPO/run_arm64.sh arm64.csv

    # on x86 machine:

    $ cd embenchen/asm_v_wasm
    $ $THIS_REPO/run_x86.sh x86.csv

5. Crunch the numbers!
