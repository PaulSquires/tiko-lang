# Quick Start

Prebuilt compilers are committed to the repository. Clone it and run one — nothing to install, nothing to add to `PATH`.

> **Run `fbc` where it lives.** It derives its installation prefix from its own path, so the binary must stay beside its `bin/`, `include/` and `lib/` directories. Copying just the executable elsewhere gives `cannot open linker script file`.

## Windows

```bat
git clone https://github.com/PaulSquires/tiko-lang.git
cd tiko-lang

toolchains\tiko-windows\fbc64.exe hello.bas
```

The Windows tree is the standard FreeBASIC **standalone** layout: `fbc64.exe` at the top level with its own `bin/`, `inc/` and `lib/`.

tiko-lang targets **win64 and linux-x86_64 only** — there is no `fbc32.exe`, and `-target win32` is rejected outright (`error 81: Invalid command-line option`). 32-bit x86 remains reachable for `dos` and `xbox`, which have no 64-bit form, so the x86 arch and the `gas` backend are still there; it is the 32-bit *targets* that are gone.

## Linux (x86-64)

```bash
git clone https://github.com/PaulSquires/tiko-lang.git
cd tiko-lang

toolchains/tiko-linux/bin/fbc hello.bas
./hello
```

A **native** Linux build, not a cross-compile — produced through fbc's own bootstrap path. The binary is committed with its executable bit set; if you extract the tree some other way, `chmod +x toolchains/tiko-linux/bin/fbc`.

## macOS

No macOS build exists — this tree has never been built on darwin. Upstream FreeBASIC supports the target, so the path is likely short, but nothing here is verified.

## Hello, new features

```freebasic
#include once "containers.bi"
using FB

'' generics
type Box( of T )
    as T value
end type

dim b as Box( of long )
b.value = 7

'' a typed container, and FOR EACH over it
dim names as Array( of string )
names.Push( "ada" )
names.Push( "grace" )

for each n as string in names
    print n
next

'' multiple return, by tuple
function MinMax( ) as (min as long, max as long)
    return (3, 9)
end function

var (lo, hi) = MinMax( )
print lo, hi

'' defer runs on the way out of the scope, on every path
scope
    defer print "cleaned up"
    print "working"
end scope
```

## The LLVM backend

`-gen llvm` is a complete backend on par with `gas`, `gas64` and `gcc`, covering both supported targets — win64 and linux-x86_64. **All you need is clang**: install the LLVM package for Windows, or your distribution's `clang`/LLVM package on Linux, so that `clang` 18 or newer is on `PATH`. Nothing is bundled and nothing else is required.

```bash
fbc -gen llvm hello.bas
```

## Next

- [Feature Index](Feature-Index) ✨ — every addition with its reference page.
- [Compatibility](Compatibility) — what changes for code you already have.
- [Keyword Index](Keyword-Index) — the whole language reference, A–Z.
