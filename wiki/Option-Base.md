[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option Base**

# Option Base

Specifies a default lower bound for array declarations

## Syntax

```freebasic
Option Base base_subscript
```

## Parameters

- `base_subscript`

## Description

`Option Base` is a statement that sets the default lower bound for any following array declarations. This default remains in effect for the rest of the module in which `Option Base` is used, and can be overridden by declaring arrays with an explicit lower bound, or with another `Option Base` statement.

 Note: initially, the default base is `0`.

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.
- In *[-lang fb](Compiler-Option-Lang)*, `Option Base` is not allowed, and the default lower bound is always `0`.

### Differences from QB

- QBASIC only supported values of `0` or `1` for `base_subscript`.
  In QBASIC the word `Base` was a reserved keyword, and couldn't be used as a variable name.  
  Arrays must always be explicitly created in FreeBASIC. QBASIC would implicitly create an array from `base_subscript` to `10` if one was used in code without being predefined.

### See also

- [`Dim`](Dim)
- [`ReDim`](Redim)
- [`LBound`](Lbound)

## Examples

```freebasic
'' Compile with the "-lang qb" or "-lang fblite" compiler switches

#lang "fblite"

Dim foo(10) As Integer      ' declares an array with indices 0-10

Option Base 5

Dim bar(15) As Integer      ' declares an array with indices 5-15

Dim baz(0 To 4) As Integer  ' declares an array with indices 0-4
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
