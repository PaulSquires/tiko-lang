[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option NoKeyword**

# Option NoKeyword

"Undefines" a reserved keyword

## Syntax

```freebasic
Option NoKeyword keyword
```

## Parameters

- `keyword`

## Description

`Option NoKeyword` is a statement that undefines a FreeBASIC reserved keyword, meaning it can be used as an identifier for a variable, object, procedure or any other symbol. The keyword is undefined for the rest of the module in which `Option NoKeyword` is used.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`#undef`](Undef)

## Examples

```freebasic
'' Compile with the "-lang fblite" compiler switch

#lang "fblite"

Option NoKeyword Int        ' remove the keyword 'int' from the internal

                            ' symbol table

Dim Int As Integer          ' declare a variable with the name 'int'
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
