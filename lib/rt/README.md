# tiko-rt

The FreeBASIC runtime library, written in FreeBASIC.

API- and ABI-compatible with fbc-modern's `libfb`, for use by the
[tiko](../tiko-lang) compiler. Built with FBC-Modern's `-gen llvm`; targets
**win64, win32 and linux-x86_64**.

> **Status: decision spike.** This exists to answer one question — *would a
> runtime written in FreeBASIC be as efficient and performant as the C one?* —
> by measuring it. tiko-lang's decisions D2 ("write no runtime") and D13
> ("recompile the C rtlib with clang") are **unchanged** until the spike reports.
> A no-go is a real outcome and most of this repo transfers to D13 either way.

Design record: [`C:\dev\docs\tiko-rt`](../docs/tiko-rt/README.md).

## The one rule

**No `rtlib/**/*.c` file is ever opened.** See [PROVENANCE.md](PROVENANCE.md).
It is a process rule with a licensing reason, it is enforced by `build/lint.sh`,
and breaking it once cannot be undone by care afterwards.

## Build

```sh
build/build.sh [Debug|Release|RelWithDebInfo] [target ...]
```

Produces `lib/<target>/libfb.a` and `lib/<target>/libfbmt.a` — one source tree,
two builds, distinguished by `-d ENABLE_MT`, exactly as the C runtime does. The
archive names are fbc's own on purpose: that is what lets `build/gate.sh` drop
tiko-rt into fbc's link line.

## Verify

Four gates. None is optional and none substitutes for another.

```sh
build/lint.sh                    # provenance + the freestanding subset
build/test.sh                    # compile-only on every target, run on the host
build/gate.sh win64 --baseline   # the harness, against the UNMODIFIED C runtime
build/gate.sh win64              # the real thing: fbc's 2,715-file suite
build/bench.sh win64             # C-libfb vs FB-libfb, the actual question
```

`gate.sh --baseline` comes first and matters most. A harness that cannot
reproduce fbc's published numbers with fbc's own runtime cannot judge a change
to it.

## Requirements

| Tool | Where |
| --- | --- |
| FBC-Modern | `C:\dev\fbc-modern` — override with `FBC_TREE` / `TKORT_FBC` |
| clang 18+ | on `PATH`; `-gen llvm` hands it the emitted IR |
| llvm-ar, llvm-nm | on `PATH` (D13: the toolchain is 100% LLVM) |
| make | for `gate.sh` only |

## Layout

```
build/    common.sh build.sh lint.sh test.sh gate.sh bench.sh
src/inc/  descriptor layouts, macro contracts, error codes
src/sys/  the OS and libc surface, and why it is bound the way it is
src/c/    the closed list of files that stay C -- see its README
tests/    unit/ (compile + run)  abi/ (layout and symbol parity)  bench/
lib/      build output
```

## Where the work is

Step table, open probes, gate numbers and measured facts:
[`docs/tiko-rt/status/spike.md`](../docs/tiko-rt/status/spike.md).
