[Home](Home) › [All Categories](Categories) › **LLVM Backend**

# LLVM Backend

tiko compiles each module to **textual LLVM IR** and runs `clang -c` on it to make an object. clang then drives the link. There is no other code generator: no C emission, no `gas` or `gas64`, and no fallback. So there is no `-gen` option, and `tiko -gen llvm hello.tko` is refused:

```
tiko-lang: error TKO0100: unknown option '-gen'
```

## What it is

The IR comes from tiko's own pipeline, not from fbc's:

1. the frontend builds a typed AST;
2. lowering turns it into **MIR**, a typed IR over basic blocks with its own verifier;
3. an **ABI pass** rewrites procedure signatures and calls for the target's C calling convention, one classifier for Win64 and one for SysV AMD64;
4. the emitter writes the LLVM IR.

`--emit-ir` writes that IR and stops: to standard output, or with `-o x.ll` to that file. `--emit-asm` runs `clang -S` on it and stops, writing `x.s`, or `<source>.s` with no `-o`. With several modules and one `-o`, each is `<name>.<n>.ll` (or `.s`). Before 2026-09-25 an `-o` turned either option into a full build, and `tiko --emit-ir x.tko -o x.ll` wrote an executable named `x.ll`. `-v` echoes every clang invocation, and `--keep-temps` keeps the `.ll` files.

Each target has its own triple:

| Target | clang triple |
| --- | --- |
| `win64-msvc` (default on Windows) | `x86_64-pc-windows-msvc` |
| `win64` (MinGW ABI) | `x86_64-w64-windows-gnu` |
| `linux-x86_64` (default on Linux) | `x86_64-pc-linux-gnu` |

## What you need: clang

**clang 18 or newer, installed by you.** Nothing is bundled.

tiko does **not** search `PATH`. It runs `C:\Program Files\LLVM\bin\clang.exe` on Windows and `/usr/bin/clang` on Linux, or whatever `TKO_CLANG` names. It takes `llvm-ar` and `llvm-rc` from the same directory. The link uses lld; on Linux it falls back to the system `ld` when there is no `ld.lld` beside clang or in `/usr/bin`.

If clang is not there, tiko says so and stops:

```
tiko-lang: error TKO0111: no usable toolchain: clang not found at 'C:/nope/clang.exe' -- set TKO_CLANG to the clang to use
```

## Inline ASM

Inline `ASM` is **refused**:

```
error TKO0407: inline assembly is not supported; compile that module with fbc
```

FreeBASIC's `ASM` is raw assembler text with direct symbol references. LLVM wants constraint strings and operands, and anything short of refusing it produces plausible-but-wrong code. A module that needs inline assembly can be built with fbc and linked in. That works for `-target win64`, the ABI fbc builds for, where objects from the two compilers link both ways.

## Optimisation and debug information

- **`-O0` to `-O3`** (written joined: `-O2`) are passed through to clang. fbc's corpus programs give the same output at all four levels (HANDOFF §9c, 2026-09-20).
- **`-g`** emits DWARF line tables. gdb breaks, steps and unwinds on both Windows targets and on Linux. Variables are not described yet.

## How it is verified

tiko's output is compared with fbc's, run for run. The figures below are dated in the repository's `HANDOFF.md`.

- **Programs.** All 68 in-scope `COMPILE_AND_RUN_OK` programs in fbc's own test corpus print what fbc's build prints (`build/runscan.sh`, 2026-09-20).
- **fbcunit suites.** 631 of fbc's suites build under both compilers, and 495 give the same results table (`build/suiterun.sh`, 2026-09-20).
- **Fuzzing.** 2,000 generated programs all print what fbc's build prints (2026-09-20).
- **Self-hosting.** tiko compiles itself to a byte-identical fixpoint on win64-msvc and linux-x86_64, at `-O0` and `-O2` (`build/bootstrap.sh`, 2026-09-21).
- **Codegen coverage.** `build/icescan.sh` compiles all 2,709 corpus files to objects and reports anything the emitter or clang refuses: 21 failures in 12 files at the last run (§9c).

---

[Home](Home) · [Keyword Index](Keyword-Index)
