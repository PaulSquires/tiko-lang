# Contributing to tiko

Thanks for your interest in tiko. Bug reports, small reproductions, tests, documentation fixes and
compiler patches are all welcome. This page covers how to build the compiler, how to test a change,
and what a pull request needs before it can be merged.

## Before you start

- **Questions and design ideas** go to
  [Discussions](https://github.com/PaulSquires/tiko-lang/discussions).
- **Bugs** go to [Issues](https://github.com/PaulSquires/tiko-lang/issues). Use the template that
  fits: compiler bug, FreeBASIC compatibility, runtime library, build/toolchain or performance.
  Include the smallest program that shows the problem, the exact command line, and the output you
  got.
- **New language features or library modules**: open a discussion or a feature request first. A
  feature is easier to agree on before it is written than after.
- **Small fixes** (a typo, a wrong message, a missing test) can go straight to a pull request.

## Setting up

You need:

- **clang 18 or newer.** tiko assembles and links with it. It is looked for at
  `C:\Program Files\LLVM\bin\clang.exe`, `/usr/bin/clang`, or on macOS at Homebrew's
  `/opt/homebrew/opt/llvm/bin/clang`; set `TIKO_CLANG` to point anywhere else.
- **A POSIX shell.** On Windows that is Git Bash; every script under `build/` is run from it.
- **macOS only:** Xcode's Command Line Tools (`xcode-select --install`).

The compiler is written in tiko, so building it needs an earlier tiko: the **seed** that
`seed/seed.lock` pins. Fetch it, lay it out where the tests link against it, and build:

```bash
sh seed/fetch-seed.sh
mkdir -p toolchains && cp -r seed/cache/windows/tiko-windows toolchains/tiko-windows   # or linux/tiko-linux
bash build/build.sh Debug --no-dll --test-runner
```

`fetch-seed.sh` checks the seed's SHA-256 before it unpacks anything. The build writes
`bin/tiko[.exe]` and the test runner `bin/tiko-test[.exe]`.

The build configurations are `Debug`, `Release` and `RelWithDebInfo`. Use `Debug` while you work.
**All three must build before a pull request is ready.**

To produce a complete, relocatable toolchain like the ones on the Releases page:

```bash
bash build/package.sh --verify
```

## Testing a change

```bash
bash build/test.sh --no-build --filter <name>   # one test, while iterating
bash build/test.sh --no-build                   # the whole suite
bash build/lint.sh                              # the compiler's lint
bash lib/rt/build/lint.sh                       # the runtime's lint, if you touched lib/rt
```

`test.sh` rebuilds the compiler first when its sources have changed; `--no-build` skips that.

**Every fix comes with a test** that fails without it. Tests are files under `tests/<area>/` whose
first lines are directives in comments:

```vb
'' TEST: cli
'' ARGS: --dump-ir tests/diagnostics/src/abstract-bare-type-arg.bas
'' EXPECT-EXIT: 1
'' EXPECT-OUT: abstract-bare-type-arg.bas(12,6): error TKO0620
'' EXPECT-MAX-DIAG: 1
```

The full list of directives (`GOLDEN`, `RUN`, `EXPECT-RUN-OUT`, per-target variants and more) is at
the top of [tools/tiko-test/tikotest.tiko](tools/tiko-test/tikotest.tiko). Golden files are
rewritten only with `--accept`, and a changed golden is reviewed like code: say in the commit why
the output changed.

**Code that only builds on Linux or macOS** (the `#else` of a `#ifdef __FB_WIN32__`, for example)
does not compile on a Windows machine at all. If you touch it, compile the unit for the other
targets too:

```bash
bin/tiko -c -target linux-x86_64 <file>
bin/tiko -c -target macos-arm64 <file>
```

## FreeBASIC compatibility

tiko compiles FreeBASIC code (`#lang "fb"`), and **fbc is the ground truth for what that code
means.** A compatibility fact is established by compiling a probe with fbc and reading what it
produces, its `-r` C output or its object symbols, not by reasoning about what fbc probably does.
When a reading and a probe disagree, the probe wins. Say in the pull request how you measured the
behaviour you are matching.

fbc's sources may be read to find out *what* is true, but **never transliterate them**: a copy
inherits fbc's bugs and cannot be checked against fbc, because it is fbc.

**`tests/vendor/` is fbc's own test suite, vendored unmodified. Never edit a byte of it.**

## Code style

The lint enforces most of these, and a lint failure fails the build:

- Spaces, not tabs; no trailing whitespace.
- No source file over **1500 lines**; split it.
- No `dim shared` and no function `static`s outside the lint's allowlists. Pass state explicitly.
- No unsigned loop counters.
- Modules include only from their own layer or below.

And by convention:

- Language keywords are lowercase (`function`, `end if`, `dim`); identifiers keep their casing.
- New code and examples use `ustring`, tiko's default string, rather than `string`.
- Public names never dodge a keyword with a trailing underscore (`Binary_`); pick another name.
- Match the file you are editing. Keep a change narrow: no drive-by reformatting or refactoring.

### Diagnostics

Every diagnostic is one row in [src/diag/diagids.ti](src/diag/diagids.ti), with a stable
`TKOnnnn` id. Nothing else in the compiler may invent a message. A new diagnostic takes the next
free number in its range, and **a diagnostic without a test in `tests/diagnostics/` does not
land.** Released ids are never renumbered or reused; a retired diagnostic stays in the table,
marked obsolete.

## Documentation

- [wiki/](wiki/) is the language and library reference. Pages describe tiko in its own terms;
  differences from FreeBASIC belong on [Compatibility](wiki/Compatibility.md).
- [book/](book/) and [by-example/](by-example/) are mdBooks. Every listing in them is a complete
  program that is compiled and run, with its output checked. A new or changed listing must be run
  on Windows, Linux and macOS before it is published.
- Examples in any of them use `ustring` and the `.tiko` / `.ti` extensions.

## Commits and pull requests

- One logical change per commit. Subjects are `area: what changed`, lowercase area, no trailing
  full stop, for example `codegen: frame records on Mach-O` or
  `std/containers: backward-shift deletion in Map and Set`.
- The body says **why**, and what was measured, when it is not obvious from the subject.
- Rebase on `master` before opening the pull request.
- In the description, list what you ran (suite, lint, the three configurations, other targets)
  and anything you could **not** check, such as a platform you do not have.

## Licensing

tiko is licensed in parts: the compiler under the GPL v2 or later, the runtime and graphics
libraries under the LGPL v2.1 or later with a static-linking exception, and the documentation
under the GNU FDL 1.3. [LICENSE](LICENSE) maps each directory to its licence. By submitting a
contribution, you agree that it is licensed under the terms of the part of the repository it
changes, and that you have the right to submit it.
