#!/bin/sh
set -eu

g++ -std=c++20 -O2 -Wall -Wextra -Wpedantic -fsanitize=undefined -fno-sanitize-recover=undefined bits.cpp bench.cpp -o /tmp/bits-check
/tmp/bits-check

g++ -std=c++20 -O2 -S -masm=intel -march=x86-64 bits.cpp -o bits-x86-64.s
g++ -std=c++20 -O2 -S -masm=intel -march=x86-64-v3 bits.cpp -o bits-x86-64-v3.s
riscv64-linux-gnu-g++ -std=c++20 -O2 -S -march=rv64gc bits.cpp -o bits-rv64gc.s
riscv64-linux-gnu-g++ -std=c++20 -O2 -S -march=rv64gc_zbb bits.cpp -o bits-rv64gc-zbb.s

g++ -std=c++20 -O2 -S -masm=intel -march=x86-64 asm_examples.cpp -o examples-x86-64.s
g++ -std=c++20 -O2 -S -masm=intel -march=x86-64-v3 asm_examples.cpp -o examples-x86-64-v3.s
riscv64-linux-gnu-g++ -std=c++20 -O2 -S -march=rv64gc asm_examples.cpp -o examples-rv64gc.s
riscv64-linux-gnu-g++ -std=c++20 -O2 -S -march=rv64gc_zbb asm_examples.cpp -o examples-rv64gc-zbb.s

printf 'function;x86-64;x86-64-v3;rv64gc;rv64gc_zbb;x86-64 compiler;rv64 compiler\n' > instructions.csv
awk '
    BEGIN {
        names[1] = "bswap32"; names[2] = "is_pow2"; names[3] = "parity32";
        names[4] = "popcount32"; names[5] = "ctz32"; names[6] = "clz32";
        names[7] = "next_pow2"; names[8] = "sign_extend"; names[9] = "sat_add32";
        for (i = 1; i <= 9; i++) wanted[names[i]] = 1;
    }
    FNR == 1 { file++; current = "" }
    /^[[:space:]]*\.ident[[:space:]]/ {
        version = $0;
        sub(/^[^"]*"/, "", version);
        sub(/".*/, "", version);
        versions[file] = version;
    }
    /^[A-Za-z_][A-Za-z_0-9]*:$/ {
        label = $0;
        sub(/:$/, "", label);
        if (label in wanted) current = label;
        next;
    }
    /^[[:space:]]*\.size[[:space:]]/ { current = ""; next }
    current != "" && /^[[:space:]]+[A-Za-z]/ { counts[file, current]++ }
    END {
        for (i = 1; i <= 9; i++) {
            name = names[i];
            printf "%s;%d;%d;%d;%d;%s;%s\n", name, counts[1, name], counts[2, name], counts[3, name], counts[4, name], versions[1], versions[3];
        }
    }
' bits-x86-64.s bits-x86-64-v3.s bits-rv64gc.s bits-rv64gc-zbb.s >> instructions.csv

printf 'build;run;seconds;sum\n' > benchmark-runs.csv
printf 'build;median_seconds;min_seconds;max_seconds;ns_per_element;speedup\n' > benchmark-summary.csv

g++ -std=c++20 -O2 -flto -march=x86-64 bits.cpp bench.cpp -o /tmp/bits-bench
baseline=$(/tmp/bits-bench --bench O2 0)
printf 'O2 median: %s s\n' "$baseline"

supports_v3=1
for flag in avx avx2 bmi1 bmi2 f16c fma movbe popcnt xsave sse4_1 sse4_2 ssse3 cx16 lahf_lm; do
    if ! grep -qm1 -w "$flag" /proc/cpuinfo; then
        supports_v3=0
    fi
done

if ! grep -qm1 -E -w 'abm|lzcnt' /proc/cpuinfo; then
    supports_v3=0
fi

if [ "$supports_v3" -eq 1 ]; then
    g++ -std=c++20 -O2 -flto -march=x86-64-v3 bits.cpp bench.cpp -o /tmp/bits-bench-v3
    median=$(/tmp/bits-bench-v3 --bench O2-x86-64-v3 "$baseline")
    printf 'O2 x86-64-v3 median: %s s\n' "$median"
else
    printf '%s\n' 'x86-64-v3 benchmark skipped: required CPU features are unavailable.'
fi
