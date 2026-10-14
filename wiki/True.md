[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **True**

# True

Intrinsic constant set by the compiler

## Syntax

```freebasic
Const True As Boolean
```

## Description

Gives the True [`Boolean`](Boolean) value where used.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__True`.

### Differences from QB

- New to FreeBASIC

### See also

- [`False`](False)
- [`Boolean`](Boolean)

## Examples

```freebasic
Dim b As Boolean = True

If b Then

    Print "b is True"

Else

    Print "b is False"

End If
```

```freebasic
b is True
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
