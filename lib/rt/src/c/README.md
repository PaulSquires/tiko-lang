# src/c -- the closed list of files that stay C

RFC-0003 section 4. Anything here must be listed below with its reason, or
`build/lint.sh` fails the build. The list is closed: it shrinks, it does not grow.

**Currently empty, and the table below is what was PREDICTED. The six files the
build actually still takes from fbc are different, and each now has a measured
reason -- see the second table.**

**Present, and compiled by `build/build.sh`:**

| File | Reason |
| --- | --- |
| `msvcinit.c` | The runtime's startup hook for the MSVC ABI, and MSVC-only -- empty on the gnu targets, where fbc's own `fbrt0.o` is on the link line doing this job. fbc names that object itself and it is not an archive member, so a program linked against tiko-rt's archive ALONE never calls `fb_hRtInit`. Measured: the process stayed in the `C` locale and `UCASE` left every accented character alone. `.CRT$XCB` sorts before the `.CRT$XCU` that module constructors land in -- RFC-0006 §4.4. |
| `msvccrt.c` | The CRT startup and the six things `ucrtbase.dll` does not export, and MSVC-only. Without it a win64-msvc link needed **Visual Studio on the compiling machine** -- not the SDK, VC Tools specifically, for `libcmt.lib`, `libvcruntime.lib`, `oldnames.lib` and `legacy_stdio_definitions.lib` -- and those are **not in Microsoft's own redistributable set**, which carries runtime DLLs and no static libraries, so shipping copies was not obviously permitted. What was missing is small, because `ucrtbase.dll` is a Windows system component exporting 2,650 symbols: `mainCRTStartup` (in no DLL), `_fltused`, `atexit` (over the exported `_crt_atexit`), `sprintf` (inline in the UCRT headers), `time`/`localtime` (named `_time64`/`_localtime64`), and `__chkstk` (in `libcmt`, and **not** in clang's `clang_rt.builtins` -- checked). Nothing is transliterated: every entry point is declared from its documented signature, and `sprintf`'s option word was read out of the SDK's `stdio.h` rather than guessed, because getting it wrong is a silent formatting difference and not a link error. |
| `msvccrtexe.c` | `mainCRTStartup`, the entry point of an EXECUTABLE, and a translation unit of its own. An archive member is pulled in only to satisfy an undefined symbol, so keeping this out of `msvccrt.c` is what stops a DLL from dragging in a reference to `main`, which a DLL has not got. It runs the `.CRT$XI*` and `.CRT$XC*` initialiser ranges, calls `main`, and exits through the UCRT's `exit` so the `_crt_atexit` handlers run and stdio is flushed. It also registers the walk of the `.CRT$XT*` TERMINATOR range: LLVM lowers `@llvm.global_dtors` into `.CRT$XTX` on this target and the real MSVC CRT walks that range inside `exit`, which the UCRT's `exit` does not do for our fragments -- so without it a module destructor was emitted correctly and never called. |
| `msvccrtdll.c` | `_DllMainCRTStartup`, the entry point of a DLL, split out for the same reason and with the same rule: a DLL link must not pull in the executable entry point or its reference to `main`. |
| `atomic.c` | FreeBASIC has no atomic operations and no way to spell a memory barrier, so there is nothing to reimplement in FB. tiko-rt's own, written against the three signatures in `fb_thread.h`; clang builtins throughout, so the MinGW and MSVC builds of it are textually identical. |
| `msvcobject.c` | `fb_Object$`'s default constructor and its RTTI record, and MSVC-only -- empty on the gnu targets, where fbc's own `oop_object.o` supplies both and the gate links it. Under MSVC there is no fbc archive to borrow from. **fbc RESERVES `__fb_ZTS6Object`**: every module it compiles gets an automatic `external global` declaration of it, so a FreeBASIC file defining it emits the name twice and clang refuses the module -- the reason recorded below, re-measured 2026-09-05. The layout was taken from fbc's own object with `llvm-objdump`, not from its sources: RTTI `{ NULL, "6OBJECT", NULL }`, a local vtable `{ NULL, &RTTI }`, and a constructor storing the vtable **plus `sizeof(header)`**, which is the bias `src/oop/istypeof.bas` subtracts back. Found by `build/gatemsvc.sh`: 728 modules of fbc's suite linked three symbols short. **NOT named `oop_object.c`:** `build/gate.sh` merges by member NAME, so that name would replace fbc's own `oop_object.o` with this file's empty gnu-side build and delete the constructor from the merged archive. It did, and the win64 gate stopped building fbcunit until this was renamed. |

**Predicted:** The spike slice (memory, strings, error, startup) needs
nothing from it. The entries expected later, each already justified in RFC-0003:

| Expected file | Reason |
| --- | --- |
| `hinit_x87.c` | x87 control word via `fstcw`/`fldcw` -- inline asm, rejected by `-gen llvm` |
| `sys_portio.c` | `inb`/`outb` -- inline asm, and the fbportio driver path |
| `cpudetect.s` | hand-written assembly |
| `fbrt0.c` `fbrt1.c` `fbrt2.c` | constructor priority **100**. PROBE-4 confirmed FB's `constructor 101` does beat every unprioritised constructor -- but 101 is FB's floor, so a user can *tie* it. The C stub sits below the range user code can express, which is why it was chosen. Staying C |

---

## What is actually still fbc's, measured 2026-09-05

`build/gate.sh` merges 199 tiko-rt objects over fbc's archive and reports **528 of
534 members replaced**. The six that survive are these, and none of them is on the
predicted list above -- every predicted entry was ported to FreeBASIC instead
(`init/hinitwin.bas`, `sys/ports.bas`).

| File | Lines | Why it stays C |
| --- | ---: | --- |
| `atomic.c` | 84 | **FreeBASIC has no atomics.** The file says so itself: these three are the smallest primitive set a refcount needs, and `docs/concurrency/RFC-0002-atomics.md` -- `FB.Atomic( of T )` -- is still a draft that needs all four backends changed. |
| `oop_object.c` | 12 | **fbc RESERVES `__fb_ZTS6Object`.** Measured: a module defining it through the ordinary two-part `extern ... alias` + `dim shared` idiom emits the symbol TWICE -- once as fbc's own `@__fb_ZTS6Object = external global %"8fb_RTTI$"`, which the compiler writes for the built-in `Object` type, and once as the definition. clang refuses the module. The same idiom with any other name emits exactly one, so this is specific to the reserved symbol and not a limitation of the idiom. |
| `oop_object_copyctor.c` | 10 | Two lines that call `oop_object.c`'s constructor. Portable in principle; kept beside the thing it cannot be separated from. |
| `oop_istypeof.c` | 21 | As above -- portable in principle, and moved only when the pair above can be. |
| `profile_cycles.c` | 349 | `__attribute__((section("fb_profilecycledata")))` with `__start_`/`__stop_` range symbols. FreeBASIC cannot place a variable in a named section, and on the MSVC ABI the mechanism does not exist at all -- RFC-0006 section 3.2. **And it is unreachable here anyway:** the records it collects come from COMPILED CODE, the LLVM backend emits none, and tiko has no -profile option in any spelling. RFC-0006 section 14. |
| `thread_call.c` | 241 | **libffi.** An external dependency, prebuilt for MinGW, and the source of the 11 known `threadcall` gate failures on every target. |

**`oop_object_copyctor.c` and `oop_istypeof.c` were on this list and are not any
more.** Neither DEFINES the reserved symbol -- one calls the constructor and the
other only reads RTTI through it -- so both are ordinary FreeBASIC modules now,
`src/oop/object_copyctor.bas` and `src/oop/istypeof.bas`. Being next to something
that cannot move was not a reason for them not to.

So the list does not shrink to zero. It shrinks to **one hard case** (`atomic.c`,
until RFC-0002 lands), **one reserved symbol** (`oop_object.c`, which is fbc's to
give up), **one section mechanism** (`profile_cycles.c`) and **one third-party
library** (`thread_call.c`), with two small files keeping the second company.

### What this costs the MSVC target

`build/build.sh` compiles FreeBASIC and nothing else -- `src/c/` has been empty
since it was created, so there is no C path in it at all. Until there is, the
win64-msvc archive is short these six and a program linking against it fails on
`fb_AtomicCasLong`. All six DO compile under `x86_64-pc-windows-msvc`: five
unchanged, and `atomic.c` with a `<windows.h>` for the `Interlocked*` family.
