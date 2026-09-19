[Home](Home) › [Tutorials](Category-Tutorials) › **Header Files (.bi)**

# Header Files (.bi)

Provides an interface for a module.

 A header file is a special kind of source file that typically only contains preprocessor statements, defines, declarations, prototypes, constants, enumerations, or similar types of statements, however, a header file can contain any valid source code if the purpose suits. What makes them different from other module (.bas) source files, is instead of being compiled directly, they are included by another source file (module or header) using the [`#include`](procedures-Include) preprocessor directive. All compiled libraries typically have one or more header files that can be included in another source file and will introduce to the compiler all the names of the procedures usable in a particular library.

FreeBASIC Header Files

Some of the keywords, constants, and procedures documented in this manual are not normally available when compiling a source code unless a specific header file is included in the source first.

- `inc/fbc-int/array.bi`
- `inc/datetime.bi`
- `inc/dir.bi`
- `inc/fbgfx.bi`
- `inc/fbio.bi`
- `inc/fblimits.bi`
- `inc/fbprng.bi`
- `inc/fbthread.bi`
- `inc/file.bi`
- `inc/fbc-int/symbol.bi`
- `inc/crt/string.bi`
- `inc/vbcompat.bi`

Case Sensitivity

Although the FreeBASIC language itself is not case-sensitive, the file system on which it is running might be. If a header file can not be found, check that FreeBASIC is searching for it the correct location and ensure that name of both the directory and filename of the header file specified in the [`#include`](procedures-Include) statement is using the correct upper and lower case letters.

Path Separators

FreeBASIC will automatically switch backslash ( \\ ) and forward slash ( / ) characters as needed for a given platform. This allows source code to be easily cross compatible.

Including a header only once

It is common that header files need to [`#include`](procedures-Include) other header files to compile correctly. FreeBASIC offers three methods for guarding against including a header file more than once.

- [`#ifndef`](Ifndef) guards in the header file
- `#include Once` where the file is included
- `#pragma Once` in the header file itself

#ifndef guards in the header file

The use of [`#ifndef`](Ifndef) and [`#define`](Define) is a common practice in nearly any language that supports preprocessing. The first time a file is included, a unique symbol is defined. The next time the same header file is included, the definition of the symbol is checked, and if it is already defined, the contents of the header file are skipped.

```freebasic
'' header.bi

#ifndef __HEADER_BI__

#define __HEADER_BI__

#print These statements will only be included Once,

#print even though header.bi might be included more

#print than Once in the same source file.

#endif
```

#include once

At the point in the source code where the header file is included, the optional `"once"` specifier of the [`#include`](procedures-Include) directive can tell the compiler to only include the source file one time.

```freebasic
'' header.bi

#include Once "fbgfx.bi"
```

```freebasic
'' module.bas

#include Once "fbgfx.bi"

#include Once "header.bi"
```

#pragma once

`#pragma Once` can be used in a header file to indicate that the header file should only be included once.

```freebasic
'' header.bi

#pragma Once

#print This header will only ever be included Once per module
```

Version

- Since fbc 1.10.0, `symbol.bi` and `fblimits.bi` are added.
- Before fbc 1.10.0 (for fbc 1.08.0 and fbc 1.09.0), `fbprng.bi` was named `fbmath.bi`.
- Since fbc 1.08.0, `array.bi` is added.
- Before fbc 1.08.0, the standard `fbmath.bi` header did not exist.

See also

- [Source Files (.bas)](Source-Files-Bas)
- [Header Files Index](External-Libraries-Index)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
