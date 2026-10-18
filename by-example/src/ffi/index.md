# Calling C

Most of the code a program could use is written in C: the operating system,
the C runtime, compression, databases, graphics. tiko calls C directly, with no
wrapper between: a C function is declared, and then called like any other.

```tiko
{{#include ../../examples/ffi/declare.tiko}}
```

**Output**

```text
{{#include ../../examples/ffi/declare.out}}
```

A C function is declared with `declare`, plus what C needs:

- **`cdecl`**: C's calling convention.
- **`alias "name"`**: the exact name the linker looks for. tiko names are not
  case-sensitive and C's are, so `alias` fixes the spelling; it also lets the
  tiko name differ, as `CLength` is C's `strlen`.
- **`lib "name"`**, optionally: the library the function lives in, which is
  then linked. The C runtime is always linked, so the example names none.

**`extern "C"` ... `end extern`** declares a block at once. Everything inside
is `cdecl` and keeps the exact spelling it was written with, so `toupper` needs
no `alias`. Inside the block `alias` still renames: `CAbs` is C's `abs`, which
needs another name because `abs` is already a tiko function.

```admonish danger title="Pitfall"
**A declaration is a promise the compiler cannot check.** It believes every
parameter type and the result type. Copy them from the C header with care, or
let the compiler read the header itself with [`#cinclude`](cinclude.md).
```

The pages that follow cover [C types](ctypes.md), [C strings](strings.md),
[callbacks](callbacks.md), [structs](structs.md), [reading a C header](cinclude.md)
and [loading a library at run time](dylib.md).

A larger C library is easiest to use as a **vendor package**: its header
already translated and its compiled code beside it, reached with one `#import`.
The toolchain ships SQLite this way; see [SQLite](../libraries/sqlite.md).

### Activities

1. Declare C's `tolower` in the `extern "C"` block and lower-case the word
   again.
2. Declare `atoi` with `declare ... cdecl alias` instead of in the block.
