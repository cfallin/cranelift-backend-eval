BEGIN {
  print "Bench,Compiler,Total Insns,JIT-code Insns";
}

/^== ([a-z]+) == asm2wasm_([a-z0-9_\.]+)\.js ==/ {
  comp = $2;
  bench = gensub(/asm2wasm_/, "", "g", $4);
  bench = gensub(/\.js/, "", "g", bench);
}

/^[0-9,]+ .*PROGRAM TOTALS$/  {
  total = gensub(/,/, "", "g", $1)+0;
}

/^([0-9,]+) .*\?\?\?$/ {
  non_symb = gensub(/,/, "", "g", $1)+0;
  print bench "," comp "," total "," non_symb;
}
