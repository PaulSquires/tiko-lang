# Quick Start

tiko is distributed as a **toolchain**: the compiler, its headers and its runtime libraries in one directory. Toolchains are build products, and the repository holds only their READMEs, so the first step is to package one for the machine you are on.

## What you need

- **clang 18 or newer.** It is not bundled. tiko does not search `PATH`: it runs `C:\Program Files\LLVM\bin\clang.exe` on Windows and `/usr/bin/clang` on Linux, or whatever `TKO_CLANG` names.
- **To build the toolchain:** [FBC-Modern](https://github.com/PaulSquires/fbc-modern)'s `fbc` compiles tiko, and FBC-Modern's tree supplies the headers. The default paths are under `C:\dev\fbc-modern`; `TKO_STAGE0` and `FBC_TREE` override them.

## Build a toolchain

From Git Bash on Windows, or from Linux or WSL:

```bash
git clone https://github.com/PaulSquires/tiko-lang.git
cd tiko-lang
bash build/package.sh --verify
```

That builds the compiler, the runtime and the graphics library, and assembles `toolchains/tiko-windows/` or `toolchains/tiko-linux/`. It then compiles **and runs** a program per target and records the result in `MANIFEST.txt`.

## Compile a program

```bat
toolchains\tiko-windows\tiko.exe hello.tiko
hello.exe
```

```bash
toolchains/tiko-linux/bin/tiko hello.tiko
./hello
```

No flags are needed. tiko finds its headers and libraries relative to its own executable, and the default target is the host's: `win64-msvc` on Windows, `linux-x86_64` on Linux.

## A first tour

```freebasic
#import "std/containers"

'' generics
type Box( of T )
    as T value
end type

dim b as Box( of int32 )
b.value = 7

'' a typed container, and for each over it
dim names as containers.Array( of ustring )
names.Push( "ada" )
names.Push( "grace" )

for each n as ustring in names
    print n
next

'' multiple return, by tuple
function MinMax( ) as (min as int32, max as int32)
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

It prints:

```
ada
grace
 3             9
working
cleaned up
```

## Next

- [Feature Index](Feature-Index) — every language feature and library, with its reference page.
- [Compatibility](Compatibility) — what changes for FreeBASIC code you already have.
- [Keyword Index](Keyword-Index) — every keyword, A–Z.
