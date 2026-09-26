# Benchmarks

Each program exists twice: a `.tko` file and the same algorithm, line for line, in C. The C is
the yardstick — both are compiled by the same LLVM, so the gap between them is what the language
costs.

| Program | What it stresses | tiko `-O2` | C, `clang -O2` |
| --- | --- | --- | --- |
| `sieve` | integer loops, array indexing, a 10 MB heap array | 0.66–0.67 s | 0.67 s |
| `mandel` | floating point in a tight loop | 0.78 s | 0.73 s |

Measured 2026-09-26 on Windows 11, win64-msvc, the packaged toolchain at `a7b9e8fb`, clang 21.1.0,
three runs each, back to back; each program times its own work and prints the time. Both outputs agree
(`664579` and `395558420`). **Linux has not been measured.** Two micro-benchmarks are a start,
not a verdict: the plan is the full Benchmarks Game set, on both targets, against C, Rust, Go and
Zig.

```bash
tiko -O2 sieve.tko -o sieve_tiko
clang -O2 sieve.c -o sieve_c
./sieve_tiko && ./sieve_c
```
