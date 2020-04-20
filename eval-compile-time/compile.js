// Usage: $jsshell ./compile.js /path/to/wasm-binary.wasm

if (scriptArgs.length !== 1) {
    console.log('one argument required: path to wasm binary');
}

let pathToBinary = scriptArgs[0];

let binary;
try {
    binary = os.file.readFile(pathToBinary, 'binary');
} catch(err) {
    console.log("couldn't read file:", err);
    quit(2);
}

try {
    let before = dateNow();
    new WebAssembly.Module(binary);
    let time = dateNow() - before;
    console.log('compilation took', time, 'milliseconds');
} catch (err) {
    console.log("couldn't compile wasm module:", err);
    quit(3);
}