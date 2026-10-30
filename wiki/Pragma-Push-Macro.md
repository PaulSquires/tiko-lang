[Home](Home) › [Preprocessor](Category-Preprocessor) › **#pragma push_macro**

# #pragma push_macro / pop_macro

Preprocessor directive

## Syntax

```freebasic
#pragma push_macro( "name" )
#pragma pop_macro( "name" )
```

## Parameters

- `name`: the macro, as a string. It may also be written bare, `push_macro( name )`; it is never expanded. Case does not matter.

## Description

`push_macro` saves the macro `name` as it stands: its definition, or the fact that it has none. The macro itself is not changed.

`pop_macro` puts back the last one saved for `name` and removes it from the stack: the macro is defined again exactly as it was, or undefined if it had no definition when it was pushed. Each name has its own stack, so pushes of one name nest and pushes of different names can interleave.

`pop_macro` for a name with nothing saved is an error (`TKO0318`).

The pair lets a header use a name that its reader may already hold as a macro, and hand the macro back unchanged afterwards. The usual case is a declaration: a header declares `const SEEK_SET` in its namespace, and a program that included `crt/stdio.bi` first has `#define SEEK_SET 0`, which would turn the declaration into `const 0 = 0`.

## Examples

```freebasic
#include once "crt/stdio.bi"     '' #define SEEK_SET 0

namespace files
    #ifdef SEEK_SET
    #pragma push_macro( "SEEK_SET" )
    #undef SEEK_SET
    const SEEK_SET = 0           '' files.SEEK_SET, not 'const 0 = 0'
    #pragma pop_macro( "SEEK_SET" )
    #else
    const SEEK_SET = 0
    #endif
end namespace

print SEEK_SET                   '' the macro is the program's again: 0
```

The `#ifdef` keeps the pragmas out of a compile where the name is no macro, so the plain `const` is all that is read there.

### See also

- [`#pragma`](Pragma)
- [`#undef`](Undef)
- [`#define`](Define)

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword
