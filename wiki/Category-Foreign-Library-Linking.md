[Home](Home) › [All Categories](Categories) › **Foreign Library Linking**

# Foreign Library Linking

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

> 📘 **Also in this category:** [#foreignlib Tutorial](modern-Foreignlib-tutorial) ✨

## Syntax

```freebasic
#foreignlib name (static|dynamic) "spec" [, "spec" ...]
```

## Description

Binds `name` to a set of libraries and adds them to the linking process.

Unlike [`#inclib`](Inclib), a `#foreignlib` spec that is not `"system:..."` is a
library **file**, resolved **relative to the source file containing the
directive** — not relative to the compiler's working directory. The target
variant is selected by filename convention, and whether the library is linked
statically or dynamically must be stated.

The bound name may then be used in place of a string literal in a
[`Lib`](Lib) clause.

## Parameters

| | |
| --- | --- |
| `name` | An identifier, visible to the end of the compilation unit and inherited by including files |
| `static` / `dynamic` | Required. Constrains which file extensions are eligible; a file of the other kind is an error, never a fallback |
| `"spec"` | `"system:foo"` passes `foo` to the linker as `-lfoo`; anything else is a library base name resolved relative to this file, or an absolute path |

## Resolution

Target tags and an extension are appended to the base name, most specific
first: `<base>_<os>_<arch><ext>`, `<base>_<os><ext>`, `<base>_<arch><ext>`,
`<base><ext>`.

`<os>` is one of `windows`, `cygwin`, `linux`, `android`, `darwin`, `dos`,
`freebsd`, `openbsd`, `netbsd`, `dragonfly`, `solaris`. `<arch>` is one of
`x86`, `x86_64`, `arm`, `aarch64`.

`<ext>` is `.a`/`.lib` for `static`; `.dll.a`/`.lib`/`.dll`, `.dylib` or `.so`
for `dynamic`, by target.

No `lib` prefix is added or stripped — the base name is used verbatim, and the
resolved file is passed to the linker by exact filename. When no candidate
matches, the error lists every path that was tried.

## Remarks

- A `#foreignlib` contributes its libraries to the link whether or not any
  declaration names it, exactly as [`#inclib`](Inclib) does.
- **`static` / `dynamic` is ignored for a `"system:"` spec.** The resolver hands
  the bare name to the linker and never consults `isstatic`, so
  `#foreignlib X dynamic "system:sqlite3"` emits `-lsqlite3` and the linker takes
  whatever it finds first — verified to link a **static** archive, silently,
  while saying `dynamic`. The keyword constrains only a **file** spec, where a
  file of the other kind is an error. See
  [#cinclude](modern-Cinclude#system-does-not-give-you-a-dynamic-link) ✨ for the
  detail and for why a real guarantee is not simply a matter of adding a flag.
- Declaring the same name twice with an identical set is allowed; with a
  different set it is an error.
- The resolved library and its absolute directory are recorded in the object
  file, so separately compiled modules carry their own link recipe.
- New to tiko-lang. Not present in FreeBASIC.

## Working with `#cinclude`

Binding to a C library is **two** jobs. `#foreignlib` does the linkage half — *where is the code?* — and [`#cinclude`](modern-Cinclude) ✨ does the header half: *what are these things?* It hands the library's own `.h` to Clang and turns it into FreeBASIC declarations for the target being built, so the `Declare` above is not written by hand at all.

Together they let a binding ship **entirely inside your own source tree**:

```freebasic
'' mylib/mylib.bi
#pragma once

#cinclude once "mylib.h"                    '' declarations, from the real header
#foreignlib MYLIB dynamic "vendor/mylib"    '' the library, per target
```

with no `Declare` and no `#ifdef` anywhere in the using code.

> ⚠️ **The two do not resolve paths the same way.** `#foreignlib` resolves its library relative to the **file containing the directive**, which is the whole reason it exists. `#cinclude` does not: the header is resolved by **Clang**, against the compiler's working directory plus any `-cinclude` directories. A vendored header therefore still needs `fbc app.bas -cinclude mylib/vendor` on the command line. See [#cinclude](modern-Cinclude) ✨ for the detail.

### See also

- [`#cinclude`](modern-Cinclude) ✨ — the header half of the same job
- [`#inclib`](Inclib)
- [`#libpath`](Libpath)
- [Compiler Option: -l](Compiler-Option-L)
- [Compiler Option: -p](Compiler-Option-P)
- [Static Libraries](Static-Libraries)
- [Shared Libraries](Shared-Libraries)

## Examples

```freebasic
'' A binding that ships its own libraries:
''
''     mylib/mylib.bi
''     mylib/lib/mylib_windows_x86_64.dll.a
''     mylib/lib/mylib_linux_x86_64.so

#foreignlib MYLIB dynamic "lib/mylib"

declare function mylib_add cdecl lib MYLIB alias "mylib_add" _
    ( byval a as long, byval b as long ) as long
```

```freebasic
'' Several libraries under one name, in link order:

#foreignlib RAYLIB static "vendor/raylib", _
            "system:winmm", "system:gdi32", "system:user32"
```

## Pages in this category

[#foreignlib](modern-Foreignlib) ✨ · [#foreignlib Tutorial](modern-Foreignlib-tutorial) ✨

---

**Source:** `docs/foreignlib/foreignlib.txt` in the tiko-lang repository.


---

[Home](Home) · [Keyword Index](Keyword-Index)
