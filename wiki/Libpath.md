[Home](Home) › [Preprocessor](Category-Preprocessor) › **#libpath**

# #libpath

Preprocessor statement to add a search path for libraries

## Syntax

```freebasic
#libpath "path"
```

## Description

Adds a library search path to the linker's list of search paths as if it had been specified on the command line with the '-p' option.

 Paths are relative to the working directory where the compiler was invoked and not relative to the directory of the source file.

 No error is generated if the path does not exist and compilation and linking will continue.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#inclib`](Inclib)
- [`#include`](procedures-Include)
- [Compiler Option: -p](Compiler-Option-P)
- [`#Cmdline`](Cmdline)
- [Static Libraries](Static-Libraries)
- [Shared Libraries](Shared-Libraries)

## Examples

```freebasic
' search the lib directory for external libraries

#libpath "lib"
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
