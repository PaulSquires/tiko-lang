# Benchmarks

Each program exists twice: a `.tiko` file and the same algorithm, line for line, in C. The C is
the yardstick — both are compiled by the same LLVM, so the gap between them is what the language
costs.

| Program | What it stresses | tiko `-O2` | C, `clang -O2` |
| --- | --- | --- | --- |
| `sieve` | integer loops, array indexing, a 10 MB heap array | 0.67–0.69 s | 0.67–0.68 s |
| `mandel` | floating point in a tight loop | 0.78–0.79 s | 0.74–0.78 s |

Measured 2026-10-17 on Windows 11, windows-x86_64, the packaged toolchain at `b360b02f`, clang 21.1.0,
three runs each, back to back; each program times its own work and prints the time. Both outputs agree
(`664579` and `395558420`). **Linux has not been measured.** Two micro-benchmarks are a start,
not a verdict: the plan is the full Benchmarks Game set, on both targets, against C, Rust, Go and
Zig.

```bash
tiko -O2 sieve.tiko -o sieve_tiko
clang -O2 sieve.c -o sieve_c
./sieve_tiko && ./sieve_c
```
