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
| `binary-trees` | 16.34 (0.96) | 16.99 | 16.94 (1.00) | 6.73 (0.40) | 9.87 (0.58) |
| `fannkuch-redux` | 23.51 (0.93) | 25.24 | 26.62 (1.05) | 23.01 (0.91) | 25.70 (1.02) |
| `fasta` | 2.79 (1.06) | 2.63 | 2.63 (1.00) | 2.99 (1.13) | 2.61 (0.99) |
| `k-nucleotide` | 5.85 (1.47) | 3.97 | 2.98 (0.75) | 11.59 (2.92) | 5.80 (1.46) |
| `mandelbrot` | 9.05 (1.01) | 8.95 | 9.31 (1.04) | 9.66 (1.08) | 9.22 (1.03) |
| `n-body` | 1.74 (0.98) | 1.77 | 1.37 (0.78) | 2.57 (1.45) | 1.37 (0.77) |
| `pidigits` | 0.46 (1.03) | 0.44 | 0.47 (1.06) | 1.12 (2.53) | 0.47 (1.05) |
| `regex-redux` | 1.92 (1.02) | 1.88 | 0.74 (0.39) | 16.98 (9.03) | 1.84 (0.98) |
| `reverse-complement` | 0.64 (1.10) | 0.58 | 0.71 (1.24) | 0.76 (1.33) | 0.53 (0.92) |
| `spectral-norm` | 0.99 (1.05) | 0.94 | 0.95 (1.01) | 0.99 (1.06) | 0.93 (0.99) |

### Ubuntu 24.04 under WSL2 (linux-x86_64)

| Program | tiko | C | Rust | Go | Zig |
| --- | ---: | ---: | ---: | ---: | ---: |
| `binary-trees` | 6.77 (0.94) | 7.22 | 6.03 (0.83) | 14.72 (2.04) | 10.12 (1.40) |
| `fannkuch-redux` | 22.77 (0.90) | 25.20 | 27.31 (1.08) | 23.08 (0.92) | 26.21 (1.04) |
| `fasta` | 2.88 (1.09) | 2.64 | 2.87 (1.09) | 3.12 (1.18) | 2.67 (1.01) |
| `k-nucleotide` | 5.90 (1.44) | 4.10 | 3.02 (0.74) | 11.54 (2.82) | 5.90 (1.44) |
| `mandelbrot` | 9.24 (1.00) | 9.22 | 9.69 (1.05) | 9.70 (1.05) | 9.56 (1.04) |
| `n-body` | 1.67 (0.92) | 1.81 | 1.36 (0.75) | 2.55 (1.41) | 1.39 (0.77) |
| `pidigits` | 0.45 (0.99) | 0.45 | 0.46 (1.02) | 0.99 (2.17) | 0.43 (0.94) |
| `regex-redux` | 1.18 (1.02) | 1.15 | 0.70 (0.61) | 16.98 (14.73) | 1.11 (0.97) |
| `reverse-complement` | 0.47 (1.44) | 0.32 | 0.47 (1.43) | 0.63 (1.93) | 0.34 (1.05) |
| `spectral-norm` | 1.03 (1.05) | 0.98 | 0.97 (0.99) | 1.02 (1.04) | 0.95 (0.97) |

Fastest of three runs, in seconds; the ratio to C is in brackets, so below 1.00 is faster than
C. Measured 2026-11-02 on one laptop (Intel Core Ultra 7 256V), each process pinned to one CPU
(a P-core on Windows; under WSL2 the pin fixes a vCPU, not a core).

| Language | Compiler | Flags |
| --- | --- | --- |
| tiko | the packaged toolchain at `fb063dfd4` | `-O2` |
| C | clang 21.1.0 on Windows, 18.1.3 on Linux -- the clang tiko itself uses | `-O2` |
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

- **k-nucleotide, 1.5x** (1.9x before `9edff823f`). It counts with `std/containers` `Map`. The
  same algorithm with a hand-written table in tiko runs at C's speed; what is left is that every
  `m[ k ] += 1` is two real calls -- the map's indexer, which LLVM declines to inline, and the
  key's `HashOf`, which lives in another module (tiko does not inline across modules yet).
  Computing the hash inside the map instead took the run from 6.0 s to 5.4 s in a test build.
- **reverse-complement on Linux, 1.4x** (1.1x on Windows). tiko's arrays are zero-filled when
  they are dimensioned and `redim preserve` copies, where C's `malloc` leaves memory untouched
  and glibc's `realloc` grows a large block without copying it; switching the two output arrays to
  `allocate` brought the Windows time into C's range. Rust pays a similar price.

### Why some languages beat C

**binary-trees: the allocator, not the compiler.** The program allocates and frees about 600
million 16-byte nodes, so it measures memory management.

- C, tiko and Rust call the system allocator once per node: the Universal CRT's heap on Windows,
  which is slow per call (16-20 s), and glibc's on Linux, whose per-thread cache is fast (6-8 s).
- Zig's default allocator in a release build is its own (`smp_allocator`): per-size pools, no
  locking. Built against the C runtime, where its default becomes `malloc`, the same Zig program
  takes 18.5 s on Windows -- slower than C.
- Go never frees a node: allocation is a pointer bump and the garbage collector reclaims whole
  dead trees, cheaply, because nearly all of them die young. But its collector needs room to
  run beside the program: with `GOMAXPROCS=1` Go takes about 15 s on both systems. On Windows
  the Go runtime ignores the CPU pin when it picks `GOMAXPROCS` (8), which is the 6.7 s above;
  on Linux it honours it (1), which is the 14.7 s. Unpinned on Linux it takes 6.8 s.

**n-body: Rust and Zig vectorize.** Their references promise the optimizer that two bodies never
overlap, so LLVM computes the x, y and z updates two doubles at a time: Rust's version has 399
packed SSE2 instructions where C's has 79. C's pointers may alias; `restrict` recovers only part
of it (1.89 s to 1.77 s, against Rust's 1.36 s in the same measurement). tiko is where C is.

**k-nucleotide: the hash tables.** Rust uses std's `HashMap` (a SwissTable) with a cheap
multiplicative hasher in place of the default SipHash, which resists hash flooding and is slow;
Zig its `AutoHashMap`; C a small open-addressing table of its own; Go its built-in map. tiko's
`Map` is open-addressed too, and like C's it picks a key's slot from the high bits of the key
times 2^64/phi: the k-mer keys are small dense integers, which that spreads over nearly distinct
slots where a random-looking hash collides at the load factor's rate.

**regex-redux: the regex engines.** Rust's `regex` crate (finite automata with literal
prefilters, no backtracking) is fastest. C, tiko and Zig all run PCRE2's JIT, so they tie. Go's
`regexp` guarantees linear time and has no JIT, and is 9-15x slower here.

**pidigits: GMP.** Everything but Go calls the same GMP, whose inner loops are hand-written
assembly; Go's pure-Go `math/big` is 2.2-2.5x slower.

**fannkuch-redux varies run to run.** It is 25-30 s of integer work, and between runs on this
machine Go and Zig have measured anywhere from 0.80x to 1.04x of C. Read a difference under
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
