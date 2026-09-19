[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **$Include**

# $Include

Metacommand statement to include contents of another source file

## Syntax

```freebasic
'$Include [once]: 'file'
Rem $Include [once]: 'file'
```

## Description

`$Include` inserts source code from another file at the point where the `$Include` metacommand appears. This has the effect of compiling the source code from the include file as though it were part of the source file that includes it. Once the compiler has reached the end of the include file, the original source file continues to be compiled.

 The `Once` specifier tells the compiler to include the file only once even if it is included several times by the source code.

 `'$Include:` exists for compatibility with QuickBASIC. It is recommended to use [`#include`](procedures-Include) instead.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- None

### See also

- [`#include`](procedures-Include)

## Examples

```freebasic
' header.bi file

Type FooType

    Bar As Byte

    Barbeque As Byte

End Type

Dim Foo As FooType
```

```freebasic
'' compile with -lang fblite or qb

#lang "fblite"

'' main.bas file

'$INCLUDE: "header.bi"

Foo.Bar = 1

Foo.Barbeque = 2
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
