[Home](Home) › [Compiler Switches](Category-Compiler-Switches) › **Option Private**

# Option Private

Specifies internal linkage by default for procedure declarations

## Syntax

```freebasic
Option Private
```

## Description

`Option Private` is a statement that gives any following procedure declarations internal linkage by default, as if declared with [`Private`](Private). This default remains in effect for the rest of the module in which `Option Private` is used, and can be overridden by declaring procedures with [`Public`](Public).

## Remarks

### Dialect Differences

- Only available in the *[-lang fblite](Compiler-Option-Lang)* and *[-lang qb](Compiler-Option-Lang)* dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OPTION_PRIVATE__`](Fb-Option-Private)
- [`Private`](Private)
- [`Public`](Public)

## Examples

```freebasic
'' Compile with the "-lang fblite" compiler switch

#lang "fblite"

Sub ProcWithExternalLinkage()

   ' ...

End Sub

Option Private

Sub ProcWithInternalLinkage()

   ' ...

End Sub

Public Sub AnotherProcWithExternalLinkage()

   ' ...

End Sub
```

---

**Category:** [Compiler Switches](Category-Compiler-Switches)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
