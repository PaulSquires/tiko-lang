[Home](Home) › [All Categories](Categories) › **LLVM Backend**

# LLVM Backend

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```bash
fbc -gen llvm hello.bas
```

`-gen llvm` is a **complete, full-featured backend**, on par with `gas`, `gas64` and `gcc` — not a partial path, not an experiment, and not the old `llvm` emitter under a new name. It emits current LLVM IR and hands it to `clang -c`.

Every tiko-lang feature works under it: generics, the iterator protocol, `FOR EACH`, tuples, `defer`, lambdas, the containers, `USTRING`, chrono, filesystem, goroutines.

## What it is

A **rewrite**. FreeBASIC's original LLVM path emitted IR that current LLVM no longer accepts, and it was broken in narrow but fatal ways — variable array indices were dropped, which is a silent miscompile rather than an error. The rewrite replaces the emitter and adds a **hand-written C ABI classifier per target**, so structure passing and returning match what the platform's C compiler does rather than approximating it.

The pipeline is one `clang` spawn per module: fbc writes the IR, clang compiles it to an object file, and the existing linker step is unchanged.

## What you need: clang

**Nothing is bundled and nothing else is required.** Install the LLVM package for Windows, or your distribution's `clang` / LLVM package on Linux, so that **`clang` 18 or newer** is on `PATH`.

The requirement is a **system** clang on purpose — an installer's self-contained clang is not what this backend targets. If clang is missing, fbc says so plainly rather than failing somewhere further down.

```bash
clang --version          # 18 or newer
fbc -gen llvm hello.bas
```

## Targets

**win64** and **linux-x86_64** — the same two the project supports. Other targets are refused with a diagnostic rather than half-supported.

The backend was originally written and gated against a third target, **win32**, which was dropped along with 32-bit x86 generally. The win32 classifier and its results below are kept as a historical record.

## The one deliberate difference: inline ASM

Inline `ASM` is **rejected, permanently and on purpose**:

```
error 374: Inline ASM is not supported by -gen llvm; compile this module with -gen gas64 or -gen gcc
```

FreeBASIC's `ASM` is raw gas/Intel text with direct symbol references. LLVM wants constraint strings and operands, and anything short of rejecting it produces plausible-but-wrong code. A real diagnostic that names the fix is better than a miscompile, and a module that needs inline assembly can be compiled with another backend and linked in.

**`NAKED` without an `ASM` body is fine.** `naked-ctor.bas`, `naked_functions.bas` and `pragma-reserve-7.bas` all compile, run, and match `-gen gcc` exactly.

## How it is verified

It passes fbc's own unit-test gate on both targets with **the same assertion counts and the same failures as `-gen gcc`**. Measured back to back, most recently on win64:

```
-gen gcc     1596109 assertions   1596098 passed   11 failed   2641 modules
-gen llvm    1596109 assertions   1596098 passed   11 failed   2641 modules
```

Byte-identical. Earlier runs, at the commits recorded in the baseline:

| Target | `-gen gcc` | `-gen llvm` | The difference |
| --- | --- | --- | --- |
| win64 | 1,596,104 / 11 failed / 2,641 | 1,596,099 / 11 failed / 2,639 | the two inline-`ASM` files |
| win32 *(pre-removal)* | 2,054,736 / 11 failed / 2,640 | 2,054,734 / 11 failed / 2,639 | `naked_functions`, backend-guarded |
| linux-x86_64 | 1,596,176 / 12 failed / 2,639 | 1,596,176 / 12 failed / 2,639 | none |

The win32 row is a record from before the 32-bit x86 targets were dropped; that target can no longer be built.

The failures are pre-existing and accounted for, not codegen defects: eleven are `ThreadCall` (the runtime is built `-DDISABLE_FFI`, so `fb_ThreadCall` returns `NULL` and every assertion on it fails on **every** backend), and the twelfth on Linux is `chrono.clocks`, which is flaky on both backends under WSL because process and thread CPU time are separate counters sampled at different granularities.

The full record — every phase, every finding, the exact reproduction steps for each target, and the ABI oracle used to check struct classification against clang itself — is in `tests/llvm/BASELINE.md` and `tests/llvm/FINDINGS.md` in the repository.

## When to use it

- **You want LLVM's code generation**, or you are building something that already lives in an LLVM toolchain.
- **You are checking a miscompile.** Two independent backends disagreeing is a fast way to find one; agreeing is evidence.
- **You need inline `ASM`** — then use `gas64` or `gcc` for that module. That is the only case where this backend is the wrong answer.

Otherwise the choice is free: all four backends are first class, and every feature works on every one of them.

---

**The full record** — every phase, every finding, the reproduction steps per target, and the ABI oracle — is in `docs/tests/llvm/BASELINE.md` and `docs/tests/llvm/FINDINGS.md` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)
