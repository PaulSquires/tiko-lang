# Benchmarks

Each program exists twice: a `.tiko` file and the same algorithm, line for line, in C. The C is
the yardstick — both are compiled by the same LLVM, so the gap between them is what the language
costs.

| Program | What it stresses | Target | tiko `-O2` | C, `clang -O2` |
| --- | --- | --- | --- | --- |
| `sieve` | integer loops, array indexing, a 10 MB heap array | Windows | 0.67–0.69 s | 0.67–0.68 s |
| | | Linux | 0.64–0.65 s | 0.65 s |
| `mandel` | floating point in a tight loop | Windows | 0.74 s | 0.74 s |
| | | Linux | 0.75 s | 0.75–0.78 s |

Measured 2026-10-17 with the packaged toolchains at `b360b02f`, on one machine: Windows 11
(windows-x86_64, clang 21.1.0) and Ubuntu 24.04 under WSL2 (linux-x86_64, clang 18.1.3). Three
runs each, back to back; each program times its own work and prints the time. Both outputs agree
on both targets (`664579` and `395558420`). Two micro-benchmarks are a start, not a verdict: the
plan is the full Benchmarks Game set, on both targets, against C, Rust, Go and Zig.

```bash
tiko -O2 sieve.tiko -o sieve_tiko
clang -O2 sieve.c -o sieve_c
./sieve_tiko && ./sieve_c
```
