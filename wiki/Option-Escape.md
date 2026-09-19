[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option Escape**

# Option Escape

Specifies that string literals should be processed for C-like escape sequences by default

## Syntax

```freebasic
Option Escape
```

## Description

`Option Escape` is a statement that causes string literals to be processed for C-like escape sequences by default. Normally, escape sequences have no effect in string literals unless the string is prefixed with the [! Operator (Escaped String Literal)](Operator-Escaped-String-Literal). This default remains in effect for the rest of the module in which `Option Escape` is used, and can be overridden by prefixing string literals with the [$ Operator (Non-Escaped String Literal)](Operator-Non-Escaped-String-Literal).

 See [Literals](Literals) in the [Programmer's Guide](Programmer-S-Guide) to learn more about escape sequences.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_ESCAPE__`](Fb-Option-Escape)
- [Operator ! (Escaped String Literal)](Operator-Escaped-String-Literal)
- [Operator $ (Non-Escaped String Literal)](Operator-Non-Escaped-String-Literal)
- [Literals](Literals)

## Examples

```freebasic
'' Compile with the "-lang fblite" compiler switch

#lang "fblite"

Option Escape

Print "Warning \a\t The path is:\r\n c:\\Freebasic\\Examples"

Print $"This string doesn't have expanded escape sequences: \r\n\t"

#include "crt.bi"

Dim As Integer a = 2, b = 3

printf("%d * %d = %d\r\n", a, b, a * b)
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
