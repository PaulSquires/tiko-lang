[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option Explicit**

# Option Explicit

Forces variables, objects and arrays to be declared before they are used

## Syntax

```freebasic
Option Explicit
```

## Description

`Option Explicit` is a statement that forces any following variable, object or array usage to be preceded by a declaration, with, for example, [`Dim`](Dim) or [`Static`](procedures-Static). This rule remains in effect for the rest of the module in which `Option Explicit` is used, and cannot be overridden.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_EXPLICIT__`](Fb-Option-Explicit)

## Examples

```freebasic
'' Compile with the "-lang qb" or "-lang fblite" compiler switches

#lang "fblite"

Option Explicit

Dim a As Integer            ' 'a' must be declared..

a = 1                       ' ..or this statement will fail to compile.
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
