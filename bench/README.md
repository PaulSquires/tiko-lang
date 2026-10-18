# Benchmarks

Two sets: the ten [Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/)
programs in tiko, C, Rust, Go and Zig (`game/`), and two older micro-benchmarks in tiko and C
(`sieve`, `mandel`).

## The Benchmarks Game suite

Each program is written to **one algorithm in all five languages**: idiomatic, single-threaded,
with C as the reference the others follow, data structure for data structure and in the same
arithmetic order. Every output is verified before it is timed, against a Python reference
(`oracle.py`) and byte for byte against C's, so a fast wrong answer cannot appear in a table.

### Windows 11 (windows-x86_64)

| Program | tiko | C | Rust | Go | Zig |
| --- | ---: | ---: | ---: | ---: | ---: |
| `binary-trees` | 19.63 (1.08) | 18.14 | 20.12 (1.11) | 7.78 (0.43) | 10.54 (0.58) |
| `fannkuch-redux` | 28.82 (0.99) | 29.04 | 27.46 (0.95) | 23.24 (0.80) | 25.85 (0.89) |
| `fasta` | 2.80 (1.06) | 2.65 | 2.73 (1.03) | 3.09 (1.17) | 2.58 (0.97) |
| `k-nucleotide` | 7.51 (1.89) | 3.98 | 2.98 (0.75) | 11.68 (2.93) | 5.80 (1.46) |
| `mandelbrot` | 9.09 (1.01) | 8.99 | 9.28 (1.03) | 9.63 (1.07) | 9.23 (1.03) |
| `n-body` | 1.76 (0.99) | 1.78 | 1.38 (0.77) | 2.60 (1.46) | 1.37 (0.77) |
| `pidigits` | 0.46 (1.07) | 0.44 | 0.47 (1.08) | 1.15 (2.65) | 0.47 (1.08) |
| `regex-redux` | 1.91 (1.01) | 1.88 | 0.74 (0.39) | 16.97 (9.00) | 1.85 (0.98) |
| `reverse-complement` | 0.62 (1.09) | 0.57 | 0.72 (1.26) | 0.78 (1.37) | 0.54 (0.95) |
| `spectral-norm` | 1.00 (1.07) | 0.93 | 0.97 (1.04) | 1.02 (1.09) | 0.93 (1.00) |

### Ubuntu 24.04 under WSL2 (linux-x86_64)

| Program | tiko | C | Rust | Go | Zig |
| --- | ---: | ---: | ---: | ---: | ---: |
| `binary-trees` | 6.55 (0.85) | 7.68 | 5.87 (0.76) | 14.50 (1.89) | 9.94 (1.29) |
| `fannkuch-redux` | 23.66 (0.94) | 25.15 | 27.15 (1.08) | 22.66 (0.90) | 25.66 (1.02) |
| `fasta` | 2.81 (1.09) | 2.59 | 2.72 (1.05) | 2.97 (1.15) | 2.63 (1.02) |
| `k-nucleotide` | 7.37 (1.86) | 3.96 | 2.97 (0.75) | 11.26 (2.85) | 5.72 (1.45) |
| `mandelbrot` | 8.98 (1.00) | 8.97 | 9.54 (1.06) | 9.50 (1.06) | 9.40 (1.05) |
| `n-body` | 1.73 (0.96) | 1.81 | 1.38 (0.76) | 2.57 (1.42) | 1.37 (0.76) |
| `pidigits` | 0.43 (1.00) | 0.43 | 0.44 (1.02) | 0.98 (2.27) | 0.42 (0.97) |
| `regex-redux` | 1.11 (1.00) | 1.11 | 0.66 (0.60) | 16.61 (14.93) | 1.08 (0.98) |
| `reverse-complement` | 0.48 (1.38) | 0.35 | 0.49 (1.42) | 0.60 (1.72) | 0.33 (0.95) |
| `spectral-norm` | 1.05 (1.08) | 0.97 | 0.96 (1.00) | 1.02 (1.05) | 0.92 (0.95) |

Fastest of three runs, in seconds; the ratio to C is in brackets, so below 1.00 is faster than
C. Measured 2026-10-18 on one laptop (Intel Core Ultra 7 256V), each process pinned to one CPU
(a P-core on Windows; under WSL2 the pin fixes a vCPU, not a core).

| Language | Compiler | Flags |
| --- | --- | --- |
| tiko | the packaged toolchain at `05f59ff8` | `-O2` |
| C | clang 21.1.0 on Windows, 19.1.1 on Linux -- the clang tiko itself uses | `-O2` |
| Rust | rustc 1.98.0 | `-C opt-level=3` |
| Go | go 1.27.2 | defaults |
| Zig | zig 0.17.0 | `-O ReleaseFast -mcpu baseline` |

Nothing is built for the native CPU, so every language gets the same baseline x86-64. pidigits
uses GMP 6.3.0 from C, tiko, Rust and Zig, and Go's `math/big`; regex-redux uses PCRE2 with its
JIT from C, tiko and Zig (10.49 on Windows, 10.42 on Linux), Rust's `regex` crate 1.13.1, and
Go's `regexp`.

### Where tiko stands

tiko and C go through the same clang, so the gap between them is what the language and its
library cost. On eight of the ten programs tiko is within 9% of C on both targets, and faster on
some. The two exceptions are both library, not code generation:

- **k-nucleotide, 1.9x.** It counts with `std/containers` `Map`. The same algorithm with a
  hand-written table in tiko runs at C's speed; what is left is the map's integer hash (a full
  splitmix mixer) and its lookup, which is a real call per update -- tiko does not inline across
  modules yet.
- **reverse-complement on Linux, 1.4x** (1.1x on Windows). tiko's arrays are zero-filled when
  they are dimensioned and `redim preserve` copies, where C's `malloc` leaves memory untouched
  and glibc's `realloc` grows a large block without copying it; switching the two output arrays to
  `allocate` brought the Windows time into C's range. Rust pays a similar price.

### Why some languages beat C

**binary-trees: the allocator, not the compiler.** The program allocates and frees about 600
million 16-byte nodes, so it measures memory management.

- C, tiko and Rust call the system allocator once per node: the Universal CRT's heap on Windows,
  which is slow per call (18-20 s), and glibc's on Linux, whose per-thread cache is fast (6-8 s).
- Zig's default allocator in a release build is its own (`smp_allocator`): per-size pools, no
  locking. Built against the C runtime, where its default becomes `malloc`, the same Zig program
  takes 18.5 s on Windows -- slower than C.
- Go never frees a node: allocation is a pointer bump and the garbage collector reclaims whole
  dead trees, cheaply, because nearly all of them die young. But its collector needs room to
  run beside the program: with `GOMAXPROCS=1` Go takes about 15 s on both systems. On Windows
  the Go runtime ignores the CPU pin when it picks `GOMAXPROCS` (8), which is the 7.8 s above;
  on Linux it honours it (1), which is the 14.5 s. Unpinned on Linux it takes 6.8 s.

**n-body: Rust and Zig vectorize.** Their references promise the optimizer that two bodies never
overlap, so LLVM computes the x, y and z updates two doubles at a time: Rust's version has 399
packed SSE2 instructions where C's has 79. C's pointers may alias; `restrict` recovers only part
of it (1.89 s to 1.77 s, against Rust's 1.36 s in the same measurement). tiko is where C is.

**k-nucleotide: the hash tables.** Rust uses std's `HashMap` (a SwissTable) with a cheap
multiplicative hasher in place of the default SipHash, which resists hash flooding and is slow;
Zig its `AutoHashMap`; C a small open-addressing table of its own; Go its built-in map.

**regex-redux: the regex engines.** Rust's `regex` crate (finite automata with literal
prefilters, no backtracking) is fastest. C, tiko and Zig all run PCRE2's JIT, so they tie. Go's
`regexp` guarantees linear time and has no JIT, and is 9-15x slower here.

**pidigits: GMP.** Everything but Go calls the same GMP, whose inner loops are hand-written
assembly; Go's pure-Go `math/big` is 2.3-2.7x slower.

**fannkuch-redux varies run to run.** It is 25-30 s of integer work, and between runs on this
machine Go and Zig have measured anywhere from 0.80x to 1.02x of C. Read a difference under
about 10% there as noise.

### Not covered

Native Linux (the Linux numbers are WSL2), multithreaded variants -- the Benchmarks Game's own
fastest programs are parallel -- and other machines.

### Running it

```bash
python bench/run.py                    # every program, every language, 3 timed runs
python bench/run.py --quick --check    # small sizes, verify only
python bench/run.py --only n-body,fasta --lang tiko,c --runs 5
```

`run.py` finds each compiler through `BENCH_TIKO`, `BENCH_CC` (else the clang tiko uses),
`BENCH_RUSTC`, `BENCH_CARGO`, `BENCH_GO` and `BENCH_ZIG`, then a `bench-tools` directory, then
`PATH`. pidigits and regex-redux also need GMP and PCRE2: on Windows a MinGW prefix holding both
(`BENCH_LIBS`), on Linux their headers (`BENCH_INC`). Builds and the generated inputs go to
`game/build/` (`~/.cache/tiko-bench` under WSL), which is not tracked.

## Micro-benchmarks: sieve and mandel

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
on both targets (`664579` and `395558420`).

```bash
tiko -O2 sieve.tiko -o sieve_tiko
clang -O2 sieve.c -o sieve_c
./sieve_tiko && ./sieve_c
```
