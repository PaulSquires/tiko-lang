[Home](Home) › [All Categories](Categories) › [C Header Import](Category-C-Header-Import) › **tiko c2t**

# tiko c2t

> **In tiko.** `tiko c2t` translates one C library header into a tiko header (`.ti`) that reads like the C it came from: comments, blank lines, order and line breaks kept, every part it could not translate marked where it stands. It needs libclang, as [`#cinclude`](modern-Cinclude) does. Measured on windows-x86_64.

## Syntax

```
tiko c2t <in.h> [-o <out.ti>|-] [-I <dir>] [-D <name>[=<value>]] [-U <name>]
                [--pass "<clang args>"] [--sysroot <dir>] [--verify]
```

## Description

[`#cinclude`](modern-Cinclude) imports a header at every build and gives back a binding for the compiler to read. `tiko c2t` is the other way to use a C library: translate its header **once**, read the result, finish the parts it marks, and ship the `.ti` with your code. What you get is a file a person can review and maintain, not a machine binding.

```
tiko c2t raylib.h -o raylib.ti
```

The header is parsed by Clang twice, once for **windows-x86_64** and once for **linux-x86_64**, and the two translations are merged into one file. Text that is the same on both targets is written once; text that differs is written under a guard the translation synthesises (`#if defined(TIKO_OS_WINDOWS)` … `#elseif defined(TIKO_OS_LINUX)` … `#endif`). The header's own `#if` lines are kept and translated, with C's platform macros spelled as tiko's own (`_WIN32` → `TIKO_OS_WINDOWS`, `__linux__` → `TIKO_OS_LINUX`, `__x86_64__` → `TIKO_ARCH_X86_64`).

A small header, before and after. The C:

```c
#ifndef MINILIB_H
#define MINILIB_H

#include <stdbool.h>

#if defined(_WIN32) && defined(BUILD_LIBTYPE_SHARED)
    #define MLAPI __declspec(dllexport)
#else
    #define MLAPI
#endif

#define ML_FLAG_VSYNC   (1 << 6)   // Set to try enabling V-Sync
#define ML_MAX(a, b)    ((a) > (b) ? (a) : (b))
#define ML_LOG(fmt, ...) printf(fmt, __VA_ARGS__)

// Color, 4 components, R8G8B8A8 (32bit)
typedef struct Color {
    unsigned char r;        // Color red value
    unsigned char a;        // Color alpha value
} Color;

typedef struct Image Image;   // defined by the implementation

MLAPI void InitWindow(int width, int height,
                      const char *title);   // Initialize window
MLAPI bool LoadImageInto(Image *image, const char *fileName);
static inline int Clamp(int v, int lo, int hi) { return v < lo ? lo : v > hi ? hi : v; }

#endif // MINILIB_H
```

and what `tiko c2t minilib.h` writes after its banner:

```freebasic
#pragma once

extern "C"

'' <stdbool.h>: built into tiko

'' c2t: export macro MLAPI (decoration, stripped where used)

#define ML_FLAG_VSYNC (1 shl 6)    '' Set to try enabling V-Sync
#define ML_MAX(a, b) iif(((a) > (b)), (a), (b))
'' C2T-TODO(function-like-macro) minilib.h:14 -- variadic: tiko has no __VA_ARGS__
'' #define ML_LOG(fmt, ...) printf(fmt, __VA_ARGS__)

'' Color, 4 components, R8G8B8A8 (32bit)
type Color
    r as uint8              '' Color red value
    a as uint8              '' Color alpha value
end type

type Image__fwd as Image      '' defined by the implementation

declare sub InitWindow( byval width_ as int32, byval height as int32, _
                        byval title as const zstring ptr )   '' Initialize window
declare function LoadImageInto( byval image as Image ptr, byval fileName as const zstring ptr ) as boolean
'' C2T-TODO(static-inline) minilib.h:27 -- static inline function 'Clamp': no symbol to link against; port the body by hand
'' static inline int Clamp(int v, int lo, int hi) { return v < lo ? lo : v > hi ? hi : v; }

end extern
```

The include guard became `#pragma once`, the export macro was recognised and stripped where it is used, `width` (a tiko word) became `width_`, and the two things with no tiko translation are marked where they stand, the C quoted beneath.

## Options

| option | |
| --- | --- |
| `-o <out.ti>` | Where the translation goes. `-` is standard output. Without `-o`, beside the header, as `<name>.ti`. The directory is made when missing |
| `-I <dir>` | A C include directory, for every pass |
| `-D <name>[=<value>]`, `-U <name>` | A C macro, for every pass. A `-D` is written into the translation as a `#define`, so the header reads the same in tiko |
| `--pass "<clang args>"` | One more pass per target, parsed with these arguments as well (`--pass "-DWITH_EXTRAS"`). Text only that pass sees is guarded by `defined(WITH_EXTRAS)` |
| `--sysroot <dir>` | The Linux pass's system headers. On Windows the Linux pass of a header that includes `<stdio.h>` needs one; the WSL root works: `--sysroot //wsl.localhost/Ubuntu` |
| `--verify` | Compile the translation for both targets in-process and check every record's size, alignment and member offsets, and every integer macro's value, against Clang's. A record that differs is refused and marked; nothing is executed |

## The banner

Every translation opens with a banner: the header's name and SHA-256, the tiko and Clang versions, the passes and the options, every name that was renamed and why, and every TODO with its line in the output and in the C. There is no timestamp, so translating the same header twice gives the same bytes, and a diff after a library upgrade shows only what changed.

## TODOs and NOTEs

A part that could not be translated becomes, at the exact place it was:

```
'' C2T-TODO(<reason>) <file.h>:<line> -- <why>
'' <the C, quoted>
```

A **TODO** is API that is missing until someone translates it by hand. A **NOTE** is information: the translation is complete but something deserves a look. The exit status says which: **0** clean, **2** at least one TODO, **1** an error (nothing written).

| TODO reason | |
| --- | --- |
| `macro` | An object-like macro whose value tiko cannot spell: a record value (a compound literal), infinity or NaN, or a name tiko does not declare |
| `function-like-macro` | A function-like macro tiko cannot write as one expression: variadic, `#` or `##`, a statement, a cast to a type it does not know |
| `static-inline` | A `static` or `static inline` function. There is no symbol to link; the body is quoted for porting |
| `conditional` | An `#if` group tiko cannot state: a compiler's identity (`_MSC_VER`, `__GNUC__`), or a branch tiko would choose differently from Clang |
| `unreached-branch` | C that neither target reaches: a branch of an `#if` no pass takes |
| `system-header` | An `#include <x.h>` with no tiko counterpart |
| `refused-type` | A declaration that names a type tiko cannot spell, or a system type no mapped header declares |
| `no-prototype` | `int f();` — C allows any arguments |
| `layout` | A record `--verify` found laid out differently from Clang |
| `guard-unstatable` | Text that differs between passes in a way no guard can say |
| `unsupported` | Anything else: a declaration a macro invocation makes, several records in one declaration |

| NOTE | |
| --- | --- |
| `inline` | A non-static `inline` function, declared: it links only if the library exports it |
| `value` | A macro written as Clang's value instead of its expression, with the reason: a cast, or a value tiko's reading of the expression would not match |
| `if-0` | `#if 0` text, kept as a comment |
| `static-assert` | A C `_Static_assert`: a compile-time check, with nothing to declare |

## Includes

Each run translates **one** header. An `#include` of another of the library's headers — beside it, below it, or found through `-I` — becomes `#include once "<path>.ti"`, written relative to the header, which is how tiko resolves `#include`. Translate each header with its own run, writing them into the same tree; a script does a whole library.

A system header goes through a table:

| C | tiko |
| --- | --- |
| `stddef.h`, `stdint.h`, `stdbool.h`, `stdarg.h`, `float.h`, `limits.h`, `iso646.h`, `stdalign.h`, `stdnoreturn.h` | nothing: built into tiko |
| `stdio.h`, `stdlib.h`, `string.h`, `time.h`, `wchar.h`, `ctype.h`, `errno.h`, `math.h`, `locale.h`, `setjmp.h` | `#include once "crt/<name>.bi"` |
| `windows.h` and its family | `#include once "windows.bi"` |
| anything else | `C2T-TODO(system-header)` |

After a mapped include the translation may name the types that header declares as C spells them: `FILE ptr` after `crt/stdio.bi`, `HWND` and `DWORD` after `windows.bi`.

`--verify` compiles the translation, so the headers it includes must be translated first, in include order.

## Types

Types are written by their fixed width, the same on both targets: `int` → `int32`, `unsigned` → `uint32`, `long long` → `int64`, `float` → `float32`, `double` → `float64`, `_Bool` → `boolean`, `size_t` → `uinteger`, `char` → `byte`, `void *` → `any ptr`. C's `long` is 4 bytes on Windows and 8 on Linux, and is written `clong` (from `crt/long.bi`). A typedef is kept by name.

A record used before it is defined is named through a hidden alias, `type Foo__fwd as Foo`, written where C declares it forward: `Foo__fwd ptr` above the definition, `Foo ptr` after it and for a record that is never defined (an opaque handle).

## Remarks

- `tiko c2t` and [`#cinclude`](modern-Cinclude) share tiko's C importer, so a type comes across the same way in both. `#cinclude` is the right tool for a header used as it is; `tiko c2t` for one you want to own.
- Names: a tiko word is renamed with `_`; a name that collides with another case-insensitively gets `_2`. Each header is its own run, so a collision **between** two headers (a macro `SDL_MALLOC` in one, a function `SDL_malloc` in another) is not seen.
- A header that cannot be parsed on its own (one that only makes sense included from another) cannot be translated on its own either.

### See also

- [C Header Import](Category-C-Header-Import) · [#cinclude](modern-Cinclude) · [#cinclude Tutorial](modern-Cinclude-tutorial)
- [`#foreignlib`](modern-Foreignlib) — linking the library a translated header declares

---

[Home](Home) · [Keyword Index](Keyword-Index)
